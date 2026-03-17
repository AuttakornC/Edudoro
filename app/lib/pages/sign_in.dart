/// File: sign_in.dart
///
/// Description: Provides the sign-in screen and authentication logic for Edudoro.
///
/// Responsibilities:
/// - Handles user authentication and token storage.
/// - Validates input and displays error messages.
/// - Navigates to loading or sign-up screens as needed.
///
/// Author: Auttakorn Camsoi
/// Course: Mobile Application Development Framework

import 'dart:convert';

import 'package:edudoro/components/ui/button.dart';
import 'package:edudoro/route.dart';
import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The sign-in screen widget for Edudoro.
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/edudoro-logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SignInForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Form widget for handling user sign-in and authentication.
class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<StatefulWidget> createState() => _SignInForm();
}

class _SignInForm extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Attempts to sign in with [email] and [password].
  ///
  /// Side effects: Stores JWT token, shows toast messages, and navigates to loading page.
  /// Handles authentication failure modes.
  Future<void> _signIn(String email, String password) async {
    try {
      final response = await fetch(
        "/auth/sign-in",
        HTTPMethod.post,
        body: <String, String>{'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        dynamic body = jsonDecode(response.body);
        final token = body['data']?['token'];

        if (token == null) {
          toast("There're some problems. Sorry for mistake.");
        }

        final storage = FlutterSecureStorage();
        await storage.write(key: 'jwt_token', value: token);
        toast("Sign In success!!");
        if (!context.mounted) return;
        Nav.goTo("/loading");
      } else if (response.statusCode == 404) {
        toast("This account is not found,");
      } else if (response.statusCode == 401) {
        toast("Passwords do not match.");
      } else {
        toast("There're some problems. Sorry for mistake.");
      }
    } catch (e) {
      toast("There're some problems. Sorry for mistake. $e");
    }
  }

  /// Sets loading state for the form.
  void _setLoading(bool status) {
    setState(() {
      _isLoading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Handles form submission and input validation.
    void onSubmit() async {
      String email = _emailController.text;
      String password = _passwordController.text;

      if (password.length < 6) {
        toast("Password must contain at least 6 characters.");
        return;
      }

      _setLoading(true);
      await _signIn(email, password);
      _setLoading(false);
    }

    return SizedBox(
      width: 364,
      child: Column(
        children: [
          SizedBox(height: 24),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              labelText: 'Email',
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            autocorrect: false,
            obscureText: true,
            enableSuggestions: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              labelText: 'Password',
            ),
          ),
          SizedBox(height: 20),

          /// Button to submit sign-in form.
          Button(label: "Sign In", onPressed: _isLoading ? () => {} : onSubmit),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don’t have any account?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(width: 6),

              /// Link to navigate to sign-up page.
              GestureDetector(
                onTap: () => {Navigator.of(context).pushNamed("/sign_up")},
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationThickness: 2.0,
                    decorationColor: Theme.of(context).colorScheme.primary,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
