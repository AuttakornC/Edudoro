import 'package:edudoro/color.dart';
import 'package:flutter/material.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FRIENDS",
          style: const TextStyle(fontWeight: FontWeight.bold, color: primary),
        ),
      ),
    );
  }
}
