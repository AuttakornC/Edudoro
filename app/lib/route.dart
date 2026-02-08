import 'package:edudoro/pages/avatar_change.dart';
import 'package:edudoro/pages/friend.dart';
import 'package:edudoro/pages/goal.dart';
import 'package:edudoro/pages/home.dart';
import 'package:edudoro/pages/landing.dart';
import 'package:edudoro/pages/profile.dart';
import 'package:edudoro/pages/setting.dart';
import 'package:edudoro/pages/shop.dart';
import 'package:edudoro/pages/sign_in.dart';
import 'package:edudoro/pages/sign_up.dart';
import 'package:edudoro/theme.dart';
import 'package:flutter/material.dart';

class RouteApp extends StatelessWidget {
  const RouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edudoro',
      theme: theme,
      routes: {
        "/": (context) => const LandingPage(),
        "/avatar_change": (context) => const AvatarChangePage(),
        "/friend": (context) => const FriendPage(),
        "/goal": (context) => const GoalPage(),
        "/home": (context) => const HomePage(),
        "/profile": (context) => const ProfilePage(),
        "/setting": (context) => const SettingPage(),
        "/shop": (context) => const ShopPage(),
        "/sign_in": (context) => const SignInPage(),
        "/sign_up": (context) => const SignUpPage(),
      },
    );
  }
}
