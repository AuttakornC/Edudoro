import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ClockSettingProvider extends ChangeNotifier {
  double _workTime = 5 / 60;
  double _restTime = 5 / 60;
  bool _isLoading = true;

  double get workTime => _workTime;
  double get restTime => _restTime;
  bool get isLoading => _isLoading;

  ClockSettingProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _setLoading(true);
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

    _setLoading(false);
  }

  void updateWorkTime(double inputWorkTime) async {
    _setLoading(true);
    final storage = FlutterSecureStorage();
    await storage.write(key: "work_time", value: inputWorkTime.toString());
    _workTime = inputWorkTime;
    _setLoading(false);
  }

  void updateRestTime(double inputRestTime) async {
    _setLoading(true);
    final storage = FlutterSecureStorage();
    _restTime = inputRestTime;
    await storage.write(key: "work_time", value: inputRestTime.toString());
    _setLoading(false);
  }

  void _setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }
}
