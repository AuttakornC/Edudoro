import 'package:edudoro/color.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PROFILE",
          style: const TextStyle(fontWeight: FontWeight.bold, color: primary),
        ),
      ),
    );
  }
}
