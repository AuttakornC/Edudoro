/*
File: goal.dart
Description: UI page for viewing and updating the user's goal for tomorrow. It initializes the input field from provider state, validates user input, and persists the value through state management.
Responsibilities:
- Render the goal input interface.
- Validate numeric goal input before saving.
- Persist the goal using provider state and show user feedback.
Dependencies:
- flutter/material.dart
- flutter/services.dart
- provider
- edudoro/providers/goal_provider.dart
- edudoro/components/ui/button.dart
- edudoro/utils/toast.dart
- edudoro/color.dart
Lifecycle:
- Initializes the text controller value from provider state in initState.
- Disposes the controller in dispose to prevent memory leaks.
Author: Chanakarn Palipol
Course: Mobile Application Development Framework
*/

import 'package:edudoro/color.dart';
import 'package:edudoro/providers/goal_provider.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:edudoro/components/ui/button.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Represents the goal configuration page for setting tomorrow's target value.
///
/// Fields:
/// - [key]: Optional widget key used by the Flutter framework.
///
/// Usage:
/// - Pushed from app navigation when the user wants to update tomorrow's goal.
/// - Works with [GoalProvider] to load and save persisted goal data.
class GoalPage extends StatefulWidget {
  /// Creates a [GoalPage].
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  final _goalController = TextEditingController(text: 'Happy');

  @override
  void initState() {
    super.initState();

    _goalController.text = context.read<GoalProvider>().tmrRound.toString();
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  void _save() {
    final goalText = _goalController.text.trim();

    if (goalText.isEmpty) {
      toast("Please enter a goal.");
      return;
    }

    final goalNumber = int.tryParse(goalText);

    if (goalNumber == null) {
      toast("You must enter the number.");
      return;
    }

    toast("Saved! Goal: $goalText");
    context.read<GoalProvider>().setTomorrowGoal(goalNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "GOAL",
          style: TextStyle(fontWeight: FontWeight.bold, color: primary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Goal For Tomorrow:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: white,
                ),
              ),
              const SizedBox(height: 12),
              _GoalField(controller: _goalController),
              const Spacer(),
              Button(
                label: "SAVE",
                onPressed: _save,
                backgroundColor: primary,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalField extends StatelessWidget {
  final TextEditingController controller;
  const _GoalField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          const Padding(padding: EdgeInsets.symmetric(horizontal: 18)),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.text,
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
              style: const TextStyle(
                color: white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Text",
                hintStyle: TextStyle(color: white),
                contentPadding: EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
