import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ClockSettingProvider extends ChangeNotifier {
  double _workTime = 5 / 60;
  double _restTime = 5 / 60;

  double get workTime => _workTime;
  double get restTime => _restTime;

  Future<bool> loadSettings() async {
    final storage = FlutterSecureStorage();

    String? workTimeStr = await storage.read(key: "work_time");
    double? workTimeParsed = double.tryParse(workTimeStr ?? "");
    if (workTimeParsed != null) {
      _workTime = workTimeParsed;
    }

    String? restTimeStr = await storage.read(key: "rest_time");
    double? restTimeParsed = double.tryParse(restTimeStr ?? "");
    if (restTimeParsed != null) {
      _restTime = restTimeParsed;
    }

    return true;
  }

  void updateWorkTime(double inputWorkTime) async {
    _workTime = inputWorkTime;
    notifyListeners();
    try {
      final storage = FlutterSecureStorage();
      await storage.write(key: "work_time", value: inputWorkTime.toString());
    } catch (e) {
      toast("Can not save work time to local storage");
    }
  }

  void updateRestTime(double inputRestTime) async {
    _restTime = inputRestTime;
    notifyListeners();
    try {
      final storage = FlutterSecureStorage();
      await storage.write(key: "rest_time", value: inputRestTime.toString());
    } catch (e) {
      toast("Can not save rest time to local storage");
    }
  }
}
