import 'package:edudoro/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GoalProvider extends ChangeNotifier {
  int _goalRound = 0;
  int _tmrRound = 0;

  int get goalRound => _goalRound;
  int get tmrRound => _tmrRound;

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

  Future<void> setTomorrowGoal(int inputRound) async {
    final storage = FlutterSecureStorage();
    final tmr = DateTime.now().add(Duration(days: 1));
    final tmrInfo = GoalStorageInfo(round: inputRound, date: dateToString(tmr));
    _tmrRound = inputRound;
    notifyListeners();
    await storage.write(key: "tmr_goal", value: tmrInfo.toString());
  }

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

class GoalStorageInfo {
  int round;
  String date;

  GoalStorageInfo({required this.round, required this.date});

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

  @override
  String toString() {
    return "${date}_$round";
  }

  void set(int _round, String _date) {
    round = _round;
    date = _date;
  }
}
