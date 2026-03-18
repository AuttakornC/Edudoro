/*
File: confirm_dialog.dart
Description: Reusable UI helper for presenting a styled confirmation dialog with customizable labels and message text.
Responsibilities:
- Provide a single function to show a consistent confirmation dialog.
- Return user intent as a nullable boolean result.
- Encapsulate dialog presentation details in a dedicated widget.
Dependencies:
- flutter/material.dart
- edudoro/color.dart
Lifecycle:
- Builds a dialog route when invoked.
- Resolves a Future result when the user confirms, cancels, or dismisses.
Author: Chanakarn Palipol
Course: Mobile Application Development Framework
*/

import 'package:edudoro/color.dart';
import 'package:flutter/material.dart';

/// Shows a styled confirmation dialog and asynchronously returns the user's
/// decision.
///
/// Returns:
/// - `true` when the user confirms.
/// - `false` when the user cancels.
/// - `null` when the dialog is dismissed without selection.
///
/// Async behavior:
/// - Returns a [Future] that completes after the dialog route is popped.
///
/// Failure modes:
/// - Throws a framework exception if [context] is invalid for dialog
///   presentation (for example, missing a [Navigator] in scope).
///
/// Side effects:
/// - Pushes a modal route onto the current navigator stack.
Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String message,
  String confirmLabel = "Confirm",
  String cancelLabel = "Cancel",
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black38,
    builder: (ctx) => _ConfirmDialog(
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
    ),
  );
}

/// Defines the visual layout for the app's reusable confirmation dialog.
///
/// Fields:
/// - [message]: Main text shown to the user.
/// - [confirmLabel]: Label for the confirm action button.
/// - [cancelLabel]: Label for the cancel action button.
///
/// Usage:
/// - Built internally by [showConfirmDialog] as the dialog content widget.
/// - Returns a boolean result through navigator pop actions.
class _ConfirmDialog extends StatelessWidget {
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  /// Creates a [_ConfirmDialog] with message and action labels.
  const _ConfirmDialog({
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: secondary,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: primary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      confirmLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primary,
                      side: const BorderSide(color: primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      cancelLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
