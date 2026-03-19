/*
 * File: goal_provider.dart
 * Description: Manages daily and tomorrow goal rounds for Edudoro, including persistence and state changes.
 * Responsibilities:
 * - Loads and updates goal rounds from secure storage.
 * - Handles logic for daily and tomorrow goals.
 * - Notifies listeners of state changes.
 * Notes: Decouples goal-setting logic from views and manages asynchronous secure storage interactions.
 * Author: Auttakorn Camsoi
 * Course: Mobile Application Development Framework
 */

import 'package:edudoro/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provider for managing daily and tomorrow goal rounds.
///
/// Fields:
/// - `_goalRound`: The target number of rounds for today.
/// - `_tmrRound`: The target number of rounds for tomorrow.
///
/// Usage:
/// - Used by goal management and display widgets to read or update the user's daily goals.
class GoalProvider extends ChangeNotifier {
  int _goalRound = 0;
  int _tmrRound = 0;

  /// The number of goal rounds for today.
  int get goalRound => _goalRound;

  /// The number of goal rounds for tomorrow.
  int get tmrRound => _tmrRound;

  /// Retrieves goal rounds from secure storage and updates state.
  ///
  /// Async nature: Performs asynchronous reads and writes to local secure storage.
  /// Failure modes: Initializes defaults to 0 if storage records are missing or unparseable.
  /// Side effects: Updates goal state, persists changes for next day rollovers, and notifies listeners.
  Future<bool> loadGoal() async {
    final storage = FlutterSecureStorage();

    DateTime now = DateTime.now();
    String nowStr = dateToString(now);
    DateTime tmr = now.add(Duration(days: 1));
    String tmrStr = dateToString(tmr);

    String? storageTodayGoal = await storage.read(key: "today_goal");
    String? storageTmrGoal = await storage.read(key: "tmr_goal");
    late GoalStorageInfo todayInfo;
    late GoalStorageInfo tmrInfo;

    if (storageTodayGoal == null) {
      todayInfo = GoalStorageInfo(round: 0, date: nowStr);
    } else {
      todayInfo = GoalStorageInfo.parse(storageTodayGoal);
    }

    if (storageTmrGoal == null) {
      tmrInfo = GoalStorageInfo(round: 0, date: tmrStr);
    } else {
      tmrInfo = GoalStorageInfo.parse(storageTmrGoal);
    }

    if (tmrInfo.date == nowStr) {
      _goalRound = tmrInfo.round;
      todayInfo.set(tmrInfo.round, tmrStr);
      tmrInfo.set(0, tmrStr);
      await storage.write(key: "today_goal", value: todayInfo.toString());
      await storage.write(key: "tmr_goal", value: tmrInfo.toString());
    } else if (todayInfo.date == nowStr) {
      _goalRound = todayInfo.round;
      if (tmrInfo.date == tmrStr) {
        _tmrRound = tmrInfo.round;
      }
    } else if (tmrInfo.date.compareTo(nowStr) == -1) {
      // storageTmr less than today
      todayInfo.set(0, nowStr);
      tmrInfo.set(0, tmrStr);
      await storage.write(key: "today_goal", value: todayInfo.toString());
      await storage.write(key: "tmr_goal", value: tmrInfo.toString());
    }
    return true;
  }

  /// Sets the goal round for tomorrow and persists to storage.
  ///
  /// Side effects: Updates tomorrow goal state and notifies listeners.
  Future<void> setTomorrowGoal(int inputRound) async {
    final storage = FlutterSecureStorage();
    final tmr = DateTime.now().add(Duration(days: 1));
    final tmrInfo = GoalStorageInfo(round: inputRound, date: dateToString(tmr));
    _tmrRound = inputRound;
    notifyListeners();
    await storage.write(key: "tmr_goal", value: tmrInfo.toString());
  }

  /// Decreases today's goal round and persists to storage.
  ///
  /// Side effects: Updates today goal state and notifies listeners.
  Future<void> decreaseTodayGoal() async {
    final storage = FlutterSecureStorage();
    final now = DateTime.now();
    _goalRound = _goalRound - 1;
    notifyListeners();
    final todayInfo = GoalStorageInfo(
      round: _goalRound,
      date: dateToString(now),
    );
    await storage.write(key: "today_goal", value: todayInfo.toString());
  }
}

/// Stores goal round and date information for persistence.
///
/// Fields:
/// - `round`: The number of rounds associated with the date.
/// - `date`: The date string in "yyyy-mm-dd" format.
///
/// Usage:
/// - Internal helper used by [GoalProvider] to format and parse storage strings.
class GoalStorageInfo {
  int round;
  String date;

  GoalStorageInfo({required this.round, required this.date});

  /// Parses a string into a [GoalStorageInfo] object.
  static GoalStorageInfo parse(String input) {
    List<String> splitedInput = input.split("_");
    if (splitedInput.length != 2) {
      return GoalStorageInfo(round: 0, date: "");
    }
    String? stringNumber = splitedInput.lastOrNull;
    int round = 0;
    if (stringNumber != null) {
      int? parseNumber = int.tryParse(stringNumber);
      round = parseNumber ?? 0;
    }

    return GoalStorageInfo(round: round, date: splitedInput[0]);
  }

  /// Returns a string representation for storage.
  @override
  String toString() {
    return "${date}_$round";
  }

  /// Sets the [round] and [date] values.
  void set(int _round, String _date) {
    round = _round;
    date = _date;
  }
}
