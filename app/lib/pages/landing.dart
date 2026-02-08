import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: TempNavigator(),
        ),
      ),
    );
  }
}

class TempNavigator extends StatelessWidget {
  const TempNavigator({super.key});

  static final List<String> _pageList = [
    "/avatar_change",
    "/friend",
    "/goal",
    "/home",
    "/profile",
    "/setting",
    "/shop",
    "/sign_in",
    "/sign_up",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _pageList.map((path) => generateButton(context, path)).toList(),
    );
  }

  Widget generateButton(BuildContext context, String path) {
    String label = "go to $path";

    return Center(
      child: TextButton(
        onPressed: () => {Navigator.of(context).pushNamed(path)},
        child: Text(label),
      ),
    );
  }
}
