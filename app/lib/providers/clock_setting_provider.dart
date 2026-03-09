import 'package:edudoro/background_service.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ClockSettingProvider extends ChangeNotifier {
  FlutterBackgroundService service = FlutterBackgroundService();

  double _workTime = 5 / 60;
  double _restTime = 5 / 60;
  int _currentTime = 0;
  bool _isRunning = false;
  PomodoroState _currentState = PomodoroState.work;

  double get workTime => _workTime;
  double get restTime => _restTime;
  int get currentTime => _currentTime;
  bool get isRunning => _isRunning;
  PomodoroState get currentState => _currentState;

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

  void start() {
    service.invoke("start");
    _isRunning = true;
    notifyListeners();
  }

  void stop() {
    service.invoke("stop");
    _isRunning = false;
    notifyListeners();
  }

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
