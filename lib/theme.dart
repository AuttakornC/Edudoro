import 'package:edudoro/color.dart';
import 'package:flutter/material.dart';

final ThemeData theme = _buildTheme();

ThemeData _buildTheme() {
  final ThemeData base = ThemeData(useMaterial3: true);
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: primary,
      onPrimary: secondary,
      secondary: secondary,
      background: background,
      error: destructive,
    ),
  );
}
