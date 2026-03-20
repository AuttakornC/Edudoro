/*
 * File: button.dart
 * Description: Defines a reusable Button widget for consistent UI actions in Edudoro.
 * 
 * Dependencies:
 * - Depends on standard Flutter material libraries.
 * 
 * Lifecycle:
 * - Stateless widget that rebuilds when its parent rebuilds or theme changes.
 * 
 * Author: Auttakorn Camsoi
 * Course: Mobile Application Development Framework
 */

import 'package:flutter/material.dart';

/// A reusable button widget with customizable label, color, and shape.
///
/// Fields:
/// - label: The text displayed on the button.
/// - onPressed: Callback function triggered when the button is tapped.
/// - backgroundColor: Optional custom background color.
/// - textStyle: Optional custom text styling.
/// - shape: Optional custom border shape.
///
/// Usage:
/// - Use for primary and secondary actions throughout the app.
class Button extends StatelessWidget {
  /// The text displayed on the button.
  final String label;

  /// Callback function triggered when the button is tapped.
  final VoidCallback onPressed;

  /// Optional custom background color.
  final Color? backgroundColor;

  /// Optional custom text styling.
  final TextStyle? textStyle;

  /// Optional custom border shape.
  final OutlinedBorder? shape;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.textStyle,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final Color _backgroundColor =
        backgroundColor ?? Theme.of(context).colorScheme.primary;
    final OutlinedBorder _shape =
        shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: _backgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        minimumSize: const Size(double.infinity, 0),
        shape: _shape,
      ),
      child: Text(label, style: textStyle),
    );
  }
}
