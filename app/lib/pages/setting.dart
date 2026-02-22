import 'package:edudoro/color.dart';
import 'package:edudoro/components/ui/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _workController = TextEditingController(text: '25');
  final _breakController = TextEditingController(text: '5');

  @override
  void dispose() {
    _workController.dispose();
    _breakController.dispose();
    super.dispose();
  }

  void _save() {
    final workTime = int.tryParse(_workController.text);
    final breakTime = int.tryParse(_breakController.text);

    if (workTime == null ||
        workTime <= 0 ||
        breakTime == null ||
        breakTime <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid times.")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Saved! Work: ${workTime}m  Break: ${breakTime}m"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SETTING",
          style: TextStyle(fontWeight: FontWeight.bold, color: primary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Work Time:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: white,
                ),
              ),
              const SizedBox(height: 12),
              _TimeField(controller: _workController),
              const SizedBox(height: 24),
              const Text(
                "Break Time:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: white,
                ),
              ),
              const SizedBox(height: 12),
              _TimeField(controller: _breakController),
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

class _TimeField extends StatelessWidget {
  final TextEditingController controller;
  const _TimeField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Icon(Icons.access_time_rounded, color: white, size: 24),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              style: const TextStyle(
                color: white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "minutes",
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
