/*
 * File: sign_up.dart
 * Description: Provides the sign-up screen and registration logic for Edudoro.
 * Responsibilities:
 * - Handles user registration and input validation.
 * - Displays error messages and navigates to sign-in screen.
 * - Manages loading state and form controls.
 * Dependencies:
 * - Depends on http.dart for network requests.
 * - Uses Button UI component and Toast utility.
 * Lifecycle:
 * - Manages form state while active. Disposes controllers when removed from tree.
 * Author: Auttakorn Camsoi
 * Course: Mobile Application Development Framework
 */

import 'package:edudoro/components/ui/button.dart';
import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';

/// The sign-up screen widget for Edudoro.
///
/// Fields:
/// - None
///
/// Usage:
/// - Used as the route "/sign_up" to allow new users to create accounts.
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                SignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Form widget for handling user registration and validation.
///
/// Fields:
/// - None
///
/// Usage:
/// - Embedded within [SignUpPage] to handle text input and submission.
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpForm();
}

class _SignUpForm extends State<SignUpForm> {
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp(
    BuildContext context,
    String username,
    String email,
    String password,
  ) async {
    try {
      final response = await fetch(
        "/auth/sign-up",
        HTTPMethod.post,
        body: <String, String>{
          'username': username,
          'password': password,
          'email': email,
        },
      );

      if (response.statusCode == 201) {
        toast("Sign up success!!");
        if (!context.mounted) return;
        Navigator.pushNamed(context, "/sign_in");
      } else if (response.statusCode == 409) {
        toast("This email already exists.");
      } else {
        toast("There're some problems. Sorry for mistake.");
      }
    } catch (err) {
      toast("There're some problems. Sorry for mistake.");
    }
  }

  void _loadingSet(bool status) {
    setState(() {
      _isLoading = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Handles form submission and input validation.
    ///
    /// Failure states: Displays error toast if inputs are too short or passwords do not match.
    void onSubmit() async {
      String username = _usernameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String confirmPassword = _confirmPasswordController.text;

      List<String> lengthError = [];

      if (username.length < 6) {
        lengthError.add("Username");
      }
      if (password.length < 6) {
        lengthError.add("Password");
      }
      if (confirmPassword.length < 6) {
        lengthError.add("Confirm password");
      }

      if (lengthError.isNotEmpty) {
        toast("${lengthError.join(", ")} must contain at least 6 characters.");
        return;
      }

      if (password != confirmPassword) {
        toast("Passwords do not match.");
        return;
      }

      _loadingSet(true);
      await _signUp(context, username, email, password);
      _loadingSet(false);
    }

    return SizedBox(
      width: 364,
      child: Column(
        children: [
          SizedBox(height: 24),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              labelText: 'Username',
            ),
          ),
          SizedBox(height: 20),
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
          TextField(
            controller: _confirmPasswordController,
            autocorrect: false,
            obscureText: true,
            enableSuggestions: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              labelText: 'Confirm Password',
            ),
          ),
          SizedBox(height: 20),

          Button(label: "Sign Up", onPressed: _isLoading ? () => {} : onSubmit),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(width: 6),

              GestureDetector(
                onTap: () => {Navigator.of(context).pushNamed("/sign_in")},
                child: Text(
                  "Sign In",
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
