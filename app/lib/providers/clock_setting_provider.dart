/// File: clock_setting_provider.dart
///
/// Description: Manages Pomodoro timer settings, state, and persistence for Edudoro.
///
/// Responsibilities:
/// - Handles timer durations and state transitions.
/// - Persists settings to secure storage.
/// - Notifies listeners of state changes.
///
/// Author: Auttakorn Camsoi
/// Course: Mobile Application Development Framework

import 'package:edudoro/background_service.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provider for Pomodoro timer settings and state.
///
/// Separates timer logic from UI and persists settings.
class ClockSettingProvider extends ChangeNotifier {
  FlutterBackgroundService service = FlutterBackgroundService();

  double _workTime = 5 / 60;
  double _restTime = 5 / 60;
  int _currentTime = 0;
  bool _isRunning = false;
  PomodoroState _currentState = PomodoroState.work;

  /// Duration for work timer in seconds.
  double get workTime => _workTime;

  /// Duration for rest timer in seconds.
  double get restTime => _restTime;

  /// Current timer value in seconds.
  int get currentTime => _currentTime;

  /// Whether the timer is running.
  bool get isRunning => _isRunning;

  /// Current Pomodoro state.
  PomodoroState get currentState => _currentState;

  /// Loads timer settings from secure storage and sets up listeners.
  ///
  /// Side effects: Updates timer state, notifies listeners, and persists settings.
  Future<bool> loadSettings() async {
    final storage = FlutterSecureStorage();

    service.invoke("checkPermission");

    service.on("time_left").listen((event) {
      if (event == null) return;
      if (event['value'] == null) return;
      _currentTime = event['value'];
      notifyListeners();
    });

    service.on("state_change").listen((event) {
      if (event == null) return;
      if (event['value'] == null) return;
      _currentState = event['value'] == PomodoroState.work.toString()
          ? PomodoroState.work
          : PomodoroState.rest;
      notifyListeners();
    });

    String? workTimeStr = await storage.read(key: "work_time");
    double? workTimeParsed = double.tryParse(
      workTimeStr ?? (25 * 60).toString(),
    );
    if (workTimeParsed != null) {
      _workTime = workTimeParsed;
    }

    String? restTimeStr = await storage.read(key: "rest_time");
    double? restTimeParsed = double.tryParse(
      restTimeStr ?? (5 * 60).toString(),
    );
    if (restTimeParsed != null) {
      _restTime = restTimeParsed;
    }

    service.invoke("setting", {'workTime': _workTime, 'restTime': _restTime});

    return true;
  }

  /// Starts the timer and updates running state.
  ///
  /// Side effects: Notifies listeners and background service.
  void start() {
    service.invoke("start");
    _isRunning = true;
    notifyListeners();
  }

  /// Stops the timer and updates running state.
  ///
  /// Side effects: Notifies listeners and background service.
  void stop() {
    service.invoke("stop");
    _isRunning = false;
    notifyListeners();
  }

  /// Updates timer duration for [updateState] and persists to storage.
  ///
  /// Side effects: Notifies listeners, updates background service, and saves to storage.
  void updateTime(PomodoroState updateState, double inputTime) async {
    if (updateState == PomodoroState.work) {
      _workTime = inputTime;
    } else {
      _restTime = inputTime;
    }
    notifyListeners();
    service.invoke("setting", {'workTime': _workTime, 'restTime': _restTime});
    try {
      final storage = FlutterSecureStorage();
      await storage.write(
        key: updateState == PomodoroState.work ? "work_time" : "rest_time",
        value: inputTime.toString(),
      );
    } catch (e) {
      toast("Can not save rest time to local storage");
    }
  }
}
