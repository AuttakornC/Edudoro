/*
 * File: string.dart
 * Description: Provides string formatting utilities for time and date display in Edudoro.
 * Responsibilities:
 * - Formats numbers with leading zeros.
 * - Converts seconds to minute:second format.
 * - Formats DateTime objects as strings.
 * Author: Auttakorn Camsoi
 * Course: Mobile Application Development Framework
 */

/// Returns a string representation of [value] padded with leading zeros to [width] digits.
String padZero(int value, int width) {
  return value.toString().padLeft(width, '0');
}

/// Converts [second] to a string in "mm:ss" format.
String secondToMinuteFormat(int second) {
  return "${(second / 60).floor()}:${padZero((second % 60).toInt(), 2)}";
}

/// Formats a [date] as a string in "yyyy-mm-dd" format.
String dateToString(DateTime date) {
  return "${padZero(date.year, 4)}-${padZero(date.month, 2)}-${padZero(date.day, 2)}";
}
