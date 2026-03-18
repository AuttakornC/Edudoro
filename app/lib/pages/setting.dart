/*
File: setting.dart
Description: UI page for configuring work and break durations used by the Pomodoro timer. It reads existing values from provider state, validates user input, and applies updated durations.
Responsibilities:
- Render editable work and break time fields.
- Validate user-entered durations before saving.
- Update timer settings, cancel active background timing, and navigate back to home.
Dependencies:
- flutter/material.dart
- flutter/services.dart
- provider
- flutter_background_service
- edudoro/providers/clock_setting_provider.dart
- edudoro/background_service.dart
- edudoro/components/ui/button.dart
- edudoro/utils/toast.dart
- edudoro/color.dart
Lifecycle:
- Initializes text controllers from provider values in initState.
- Disposes controllers in dispose to release resources.
Author: Chanakarn Palipol
Course: Mobile Application Development Framework
*/

import 'package:edudoro/background_service.dart';
import 'package:edudoro/color.dart';
import 'package:edudoro/components/ui/button.dart';
import 'package:edudoro/providers/clock_setting_provider.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';

/// Represents the settings page for Pomodoro work and break durations.
///
/// Fields:
/// - [key]: Optional widget key used by the Flutter framework.
///
/// Usage:
/// - Opened when the user wants to adjust timer configuration.
/// - Persists updates through [ClockSettingProvider] and coordinates with
///   background service behavior.
class SettingPage extends StatefulWidget {
  /// Creates a [SettingPage].
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _workController = TextEditingController(text: '25');
  final _breakController = TextEditingController(text: '5');

  @override
  void initState() {
    super.initState();

    _workController.text = (context.read<ClockSettingProvider>().workTime / 60)
        .toString();

    _breakController.text = (context.read<ClockSettingProvider>().restTime / 60)
        .toString();
  }

  @override
  void dispose() {
    _workController.dispose();
    _breakController.dispose();
    super.dispose();
  }

  void _save() {
    final workTime = double.tryParse(_workController.text);
    final breakTime = double.tryParse(_breakController.text);

    if (workTime == null ||
        workTime <= 0 ||
        breakTime == null ||
        breakTime <= 0) {
      toast("Please enter valid times.");
      return;
    }

    final service = FlutterBackgroundService();

    service.invoke("cancel");
    context.read<ClockSettingProvider>().updateTime(
      PomodoroState.work,
      workTime * 60,
    );
    context.read<ClockSettingProvider>().updateTime(
      PomodoroState.rest,
      breakTime * 60,
    );
    toast("Saved! Work: ${workTime}m  Break: ${breakTime}m");
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SETTING",
          style: TextStyle(fontWeight: FontWeight.bold, color: primary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Work Time:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: white,
                ),
              ),
              const SizedBox(height: 12),
              _TimeField(controller: _workController),
              const SizedBox(height: 24),
              const Text(
                "Break Time:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: white,
                ),
              ),
              const SizedBox(height: 12),
              _TimeField(controller: _breakController),
              const Spacer(),
              Button(
                label: "SAVE",
                onPressed: _save,
                backgroundColor: primary,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  final TextEditingController controller;
  const _TimeField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Icon(Icons.access_time_rounded, color: white, size: 24),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              style: const TextStyle(
                color: white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "minutes",
                hintStyle: TextStyle(color: white),
                contentPadding: EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
