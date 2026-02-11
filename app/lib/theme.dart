import 'package:edudoro/color.dart';
import 'package:edudoro/components/util/svgIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
