/// File: loading.dart
///
/// Description: Displays a loading screen and initializes app state before navigating to the home page.
///
/// Responsibilities:
/// - Loads coin, clock, and goal providers asynchronously.
/// - Navigates to the home page when initialization is complete.
/// - Shows a progress indicator during loading.
///
/// Author: Auttakorn Camsoi
/// Course: Mobile Application Development Framework

import 'package:edudoro/providers/clock_setting_provider.dart';
import 'package:edudoro/providers/coin_provider.dart';
import 'package:edudoro/providers/goal_provider.dart';
import 'package:edudoro/route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The loading screen widget for Edudoro.
class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    /// Triggers loading of providers after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLoading();
    });
  }

  /// Loads all providers and navigates to "/home" when successful.
  ///
  /// Side effects: Navigates to home page and updates provider states.
  Future<void> _startLoading() async {
    final coinProv = context.read<CoinProvider>();
    final clockProv = context.read<ClockSettingProvider>();
    final goalProv = context.read<GoalProvider>();

    final arraySuccess = await Future.wait([
      coinProv.loadCoin(),
      clockProv.loadSettings(),
      goalProv.loadGoal(),
    ]);

    if (arraySuccess.every((element) => element)) {
      Nav.goTo("/home", removeAll: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/edudoro-logo.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(),

            /// Shows a circular progress indicator while loading.
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
