import 'package:edudoro/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../components/util/svgIcon.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'jwt_token');
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/sign_in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PROFILE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            color: primary,
            tooltip: "Logout",
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 60),

                Container(
                  width: 129,
                  height: 129,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.secondary,
                  ),
                  child: Center(
                    child: SVGIcon(
                      src: "assets/icons/ProfileIcon.svg",
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                InkWell(
                  onTap: () => Navigator.of(context).pushNamed("/avatar_change"),
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                      decorationColor: colors.onPrimary,
                      decorationThickness: 2,
                      fontWeight: FontWeight.bold,
                      color: colors.onPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  "Username",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "example@example.com",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}