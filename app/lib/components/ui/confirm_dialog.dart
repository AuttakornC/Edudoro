import 'package:edudoro/color.dart';
import 'package:flutter/material.dart';

/// Shows a styled confirmation dialog and returns `true` if confirmed,
/// `false` if cancelled, or `null` if dismissed.
///
/// Usage:
/// ```dart
/// final confirmed = await showConfirmDialog(
///   context: context,
///   message: "Are you sure to\nbuy this item?",
/// );
/// if (confirmed == true) { /* proceed */ }
/// ```

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

class _ConfirmDialog extends StatelessWidget {
  final String message;
  final String confirmLabel;
  final String cancelLabel;

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
