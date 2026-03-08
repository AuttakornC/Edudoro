import 'package:edudoro/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void changePage(BuildContext context) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: "jwt_token");
  if (token == null) {
    Nav.goTo("/sign_in", removeAll: true);
  } else {
    Nav.goTo("/loading", removeAll: true);
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    changePage(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/edudoro-logo.png",
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
