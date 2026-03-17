/// File: theme.dart
///
/// Description: Defines the global [ThemeData] and theming configuration for the Edudoro application.
///
/// Responsibilities:
/// - Centralizes color, typography, and widget theming.
/// - Provides a consistent look and feel across the app.
///
/// Author: Auttakorn Camsoi
/// Course: Mobile Application Development Framework

import 'package:edudoro/color.dart';
import 'package:edudoro/components/util/svgIcon.dart';
import 'package:flutter/material.dart';

/// The main theme configuration for the Edudoro app.
final ThemeData theme = _buildTheme();

/// Builds and returns the [ThemeData] for the application.
///
/// Customizes color scheme, app bar, and action icons.
ThemeData _buildTheme() {
  final ThemeData base = ThemeData(useMaterial3: true);
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: primary,
      onPrimary: secondary,
      secondary: secondary,
      background: background,
      surface: background, // Added to replace deprecated background
      error: destructive,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(backgroundColor: background),
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) => IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: SVGIcon(src: "assets/icons/BackIcon.svg"),
      ),
    ),
  );
}
