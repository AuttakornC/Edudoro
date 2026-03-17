/// File: home.dart
///
/// Description: Main entry UI for Edudoro, displaying timer, coin, goal, and navigation controls.
///
/// Responsibilities:
/// - Provides the home screen layout and navigation.
/// - Displays Pomodoro timer, coin balance, and goal progress.
/// - Handles navigation to friend, profile, goal, and settings pages.
///
/// Author: Auttakorn Camsoi
/// Course: Mobile Application Development Framework

import 'package:edudoro/color.dart';
import 'package:edudoro/components/pages/home/home_clock.dart';
import 'package:edudoro/components/pages/home/home_coin.dart';
import 'package:edudoro/components/util/svgIcon.dart';
import 'package:edudoro/providers/goal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The main home screen widget for Edudoro.
///
/// Created via Navigator after loading completes.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(context: context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [HomeGoalButton(), HomeClock()],
              ),
            ),
            HomeFooter(),
          ],
        ),
      ),
    );
  }
}

/// Custom app bar for the home screen, with navigation to friend and profile pages.
class HomeAppBar extends AppBar {
  HomeAppBar({super.key, required BuildContext context})
    : super(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => {Navigator.of(context).pushNamed("/friend")},
              icon: SVGIcon(
                src: "assets/icons/FriendsIcon.svg",
                height: 24,
                width: 24,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            IconButton(
              onPressed: () => {Navigator.of(context).pushNamed("/profile")},
              icon: SVGIcon(
                src: "assets/icons/ProfileIcon.svg",
                height: 24,
                width: 24,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      );
}

/// Footer widget for the home screen, with navigation to shop and settings.
class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HomeCoin(),
          IconButton(
            onPressed: () => {Navigator.of(context).pushNamed("/setting")},
            icon: SVGIcon(src: "assets/icons/SettingIcon.svg"),
          ),
        ],
      ),
    );
  }
}

/// Displays the user's goal progress and provides navigation to set new goals.
class HomeGoalButton extends StatefulWidget {
  const HomeGoalButton({super.key});

  @override
  State<HomeGoalButton> createState() => _HomeGoalButtonState();
}

class _HomeGoalButtonState extends State<HomeGoalButton> {
  @override
  Widget build(BuildContext context) {
    final goalRound = context.select<GoalProvider, int>(
      (value) => value.goalRound,
    );

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(124, 130, 0, 0),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Text(
            "Goal: Finished $goalRound Round",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => {Navigator.of(context).pushNamed("/goal")},

          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            "New Goal For Tomorrow +",
            style: TextStyle(
              fontSize: 14,
              color: white,
              decoration: TextDecoration.underline,
              decorationColor: white,
            ),
          ),
        ),
      ],
    );
  }
}
