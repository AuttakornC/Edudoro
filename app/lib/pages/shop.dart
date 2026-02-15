import 'package:edudoro/color.dart';
import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SHOP",
          style: const TextStyle(fontWeight: FontWeight.bold, color: primary),
        ),
      ),
    );
  }
}
