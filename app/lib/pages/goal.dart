import 'package:edudoro/color.dart';
import 'package:flutter/material.dart';
import 'package:edudoro/components/ui/button.dart';
import 'package:flutter/services.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  final _goalController = TextEditingController(text: 'Happy');

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  void _save() {
    final goalText = _goalController.text.trim();

    if (goalText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a goal.")));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Saved! Goal: $goalText")));
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
