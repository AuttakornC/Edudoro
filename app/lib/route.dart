/*
 * File: route.dart
 * Description: Defines global navigation routes and navigation utilities for the Edudoro application.
 * Responsibilities:
 * - Maps route names to page widgets for navigation.
 * - Provides a global NavigatorState key for navigation control.
 * - Offers utility methods for programmatic navigation.
 * Dependencies: Page widgets across the application.
 * Lifecycle: Application root level, active throughout the app lifecycle.
 * Author: Auttakorn Camsoi
 * Course: Mobile Application Development Framework
 */

import 'package:edudoro/pages/avatar_change.dart';
import 'package:edudoro/pages/friend.dart';
import 'package:edudoro/pages/goal.dart';
import 'package:edudoro/pages/home.dart';
import 'package:edudoro/pages/landing.dart';
import 'package:edudoro/pages/loading.dart';
import 'package:edudoro/pages/profile.dart';
import 'package:edudoro/pages/setting.dart';
import 'package:edudoro/pages/shop.dart';
import 'package:edudoro/pages/sign_in.dart';
import 'package:edudoro/pages/sign_up.dart';
import 'package:edudoro/theme.dart';
import 'package:flutter/material.dart';

/// A stateless widget that sets up navigation and theming for the app.
///
/// Fields:
/// - None
///
/// Usage:
/// - Serves as the root widget passed to `runApp()`.
class RouteApp extends StatelessWidget {
  const RouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edudoro',
      theme: theme,
      navigatorKey: Nav.key,

      /// Maps route names to their corresponding page widgets.
      routes: {
        "/": (context) => const LandingPage(),
        "/loading": (context) => const LoadingPage(),
        "/sign_in": (context) => const SignInPage(),
        "/sign_up": (context) => const SignUpPage(),
        "/avatar_change": (context) => const AvatarChangePage(),
        "/friend": (context) => const FriendPage(),
        "/goal": (context) => const GoalPage(),
        "/home": (context) => const HomePage(),
        "/profile": (context) => const ProfilePage(),
        "/setting": (context) => const SettingPage(),
        "/shop": (context) => const ShopPage(),
      },
    );
  }
}

/// Provides global navigation utilities and a NavigatorState key.
///
/// Fields:
/// - `key`: A global key used to interact with the app's Navigator directly via state without context.
///
/// Usage:
/// - Call `Nav.goTo` from anywhere to push or replace routes.
class Nav {
  static final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  /// Navigates to the route named [routeName].
  ///
  /// If [removeAll] is true, removes all previous routes from the stack.
  ///
  /// Side effects: Changes the current page in the app.
  static void goTo(String routeName, {bool? removeAll}) {
    if (removeAll != null && removeAll) {
      key.currentState?.pushNamedAndRemoveUntil(routeName, (route) => false);
      return;
    }
    key.currentState?.pushNamed(routeName);
  }
}
