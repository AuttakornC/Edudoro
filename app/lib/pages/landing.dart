/*
 * File: landing.dart
 * Description: Displays the landing screen and redirects users based on authentication state.
 * Responsibilities:
 * - Checks for authentication token in secure storage.
 * - Navigates to sign-in or loading page based on token presence.
 * - Shows the Edudoro logo during transition.
 * Dependencies:
 * - Depends on FlutterSecureStorage for auth token checking.
 * - Uses Nav for routing.
 * Lifecycle:
 * - Shown at app startup, evaluates auth state, and redirects immediately.
 * Author: Auttakorn Camsoi
 * Course: Mobile Application Development Framework
 */

import 'package:edudoro/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Redirects to sign-in or loading page based on authentication token.
///
/// Async nature: Asynchronously reads secure storage to check the JWT token.
/// Failure modes: Defaults to sign-in if no token is found or storage read fails.
/// Side effects: Navigates to another page and reads secure storage.
void changePage(BuildContext context) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: "jwt_token");
  if (token == null) {
    Nav.goTo("/sign_in", removeAll: true);
  } else {
    Nav.goTo("/loading", removeAll: true);
  }
}

/// The landing screen widget for Edudoro.
///
/// Fields:
/// - None
///
/// Usage:
/// - Used as the initial route "/" to determine user session status.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    changePage(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/edudoro-logo.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
