import 'package:edudoro/components/ui/button.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
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
    );
  }
}

class SignInForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInForm();
}

class _SignInForm extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 364,
      child: Column(
        children: [
          SizedBox(height: 24),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
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
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              labelText: 'Password',
            ),
          ),
          SizedBox(height: 20),
          Button(label: "Sign In", onPressed: () => {}),
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
