/*
* File: main.dart
* Description: Application entry point.
*              Initializes the Flutter framework and launches the root widget.
*
* Notes:
* - Contains global app configuration
* - Should remain lightweight
*
* Author: Auttakorn Camsoi
* Course: Mobile Application Development Framework
*/

import 'package:edudoro/background_service.dart';
import 'package:edudoro/providers/clock_setting_provider.dart';
import 'package:edudoro/providers/coin_provider.dart';
import 'package:edudoro/providers/goal_provider.dart';
import 'package:edudoro/route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  /// Ensures Flutter engine and plugins are initialized before any async work.
  WidgetsFlutterBinding.ensureInitialized();

  /// Initializes background services required for the app.
  ///
  /// Side effects: Starts background service for notifications and timers.
  /// Waits for async setup to complete before running the app.
  await initializeService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClockSettingProvider()),
        ChangeNotifierProvider(create: (_) => CoinProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
      ],
      child: const RouteApp(),
    ),
  );
}
