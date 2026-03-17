/// File: home_clock.dart
///
/// Description: Displays the Pomodoro timer and handles timer state, coin rewards, and goal progress in the home screen.
///
/// Responsibilities:
/// - Shows timer progress and controls.
/// - Updates coin and goal state based on timer events.
/// - Handles async network requests and state changes.
///
/// Author: Auttakorn Camsoi
/// Course: Mobile Application Development Framework

import 'package:edudoro/background_service.dart';
import 'package:edudoro/color.dart';
import 'package:edudoro/components/ui/button.dart';
import 'package:edudoro/providers/clock_setting_provider.dart';
import 'package:edudoro/providers/coin_provider.dart';
import 'package:edudoro/providers/goal_provider.dart';
import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/string.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';

/// Widget displaying the Pomodoro timer and controls.
///
/// Created via Navigator from the home screen.
class HomeClock extends StatefulWidget {
  const HomeClock({super.key});

  @override
  State<HomeClock> createState() => _HomeClockState();
}

class _HomeClockState extends State<HomeClock>
    with SingleTickerProviderStateMixin {
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();

    /// Listens for timer state changes and updates coin/goal.
    FlutterBackgroundService().on("state_change").listen((event) async {
      if (event == null) return;
      if (event['value'] == null) return;
      if (event['value'] == PomodoroState.work.toString() && _isRunning) {
        await _increaseCoin(5);
        await _decreaseRound();
      }
    });
  }

  /// Decreases today's goal round and increases coin if last round.
  ///
  /// Side effects: Updates goal provider and coin provider.
  Future<void> _decreaseRound() async {
    final goalProvider = context.read<GoalProvider>();

    if (goalProvider.goalRound == 0) return;
    if (goalProvider.goalRound == 1) {
      await _increaseCoin(20);
    }
    await goalProvider.decreaseTodayGoal();
  }

  /// Increases the user's coin balance by [coinNumber].
  ///
  /// Side effects: Updates coin provider and shows toast on failure.
  /// Waits for async network request to complete.
  Future<void> _increaseCoin(int coinNumber) async {
    try {
      final response = await fetch(
        "/score",
        HTTPMethod.post,
        body: <String, dynamic>{'score': coinNumber},
        withAuth: true,
      );
      if (response.statusCode == 201) {
        final coinContext = context.read<CoinProvider>();
        coinContext.increaseCoin(coinNumber);
      } else {
        toast("There're some problems to increase coin. Sorry for mistake.");
      }
    } catch (e) {
      print("Increase coin fail: $e");
      toast("There're some problems to increase coin. Sorry for mistake. $e");
    }
  }

  /// Starts the timer and updates running state.
  ///
  /// Side effects: Notifies [ClockSettingProvider] and updates UI.
  void _start() {
    context.read<ClockSettingProvider>().start();
    _isRunning = true;
  }

  /// Stops the timer and updates running state.
  ///
  /// Side effects: Notifies [ClockSettingProvider] and updates UI.
  void _stop() {
    context.read<ClockSettingProvider>().stop();
    _isRunning = false;
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = context.select<ClockSettingProvider, int>(
      (models) => models.currentTime,
    );

    final isRunning = context.select<ClockSettingProvider, bool>(
      (models) => models.isRunning,
    );

    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(aspectRatio: 1, child: ProgressBar()),
              Text(
                secondToMinuteFormat(currentTime),
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 32),
          Button(
            label: !isRunning ? "START" : "GIVE UP",
            onPressed: !isRunning ? _start : _stop,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated progress bar for the Pomodoro timer.
class ProgressBar extends StatefulWidget {
  const ProgressBar({super.key});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clockProvider = context.watch<ClockSettingProvider>();
    final currentSecond = clockProvider.currentTime;
    late double fullSecond;
    if (clockProvider.currentState == PomodoroState.work) {
      fullSecond = clockProvider.workTime;
    } else {
      fullSecond = clockProvider.restTime;
    }

    if (fullSecond == 0) {
      fullSecond = 1;
    }

    _animationController.animateTo(
      currentSecond / fullSecond,
      duration: const Duration(seconds: 1),
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CircularProgressIndicator(
          value: _animationController.value,
          strokeWidth: 16,
          backgroundColor: white,
        );
      },
    );
  }
}
