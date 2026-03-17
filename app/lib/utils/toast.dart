/// File: toast.dart
///
/// Description: Provides a utility function to display toast notifications in Edudoro.
///
/// Responsibilities:
/// - Shows styled toast messages to the user.
/// - Centralizes toast configuration for consistent UI feedback.
///
/// Author: Auttakorn Camsoi
/// Course: Mobile Application Development Framework

import 'package:edudoro/color.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Displays a toast notification with the given [msg].
///
/// Side effects: Shows a UI overlay message at the top of the screen.
void toast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    timeInSecForIosWeb: 5,
    backgroundColor: secondary,
    textColor: primary,
    gravity: ToastGravity.TOP,
    toastLength: Toast.LENGTH_LONG,
  );
}
