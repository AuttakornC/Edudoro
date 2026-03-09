/*
File: color_hex_converter.dart
Description: This file defines a utility function to convert hexadecimal color codes to Flutter's Color objects.

Responsibilities:
- Provide a function `hexToColor` that takes a hexadecimal color code as a string and returns a Color object.

Author: 4KV6
Course: Mobile Application Development Frameworks
*/

import 'package:flutter/material.dart';

/// The `hexToColor` function converts a hexadecimal color code string to a Flutter `Color` object.
///
/// Parameters:
/// - `code`: A string representing the hexadecimal color code. It can optionally start with a '#' character. The expected format is either 'RRGGBB' or '#RRGGBB'.
///
/// Returns:
/// - A `Color` object corresponding to the provided hexadecimal color code. The alpha value is set to 255 (fully opaque) by default.
///
/// Usage:
/// ```dart
/// Color myColor = hexToColor("#FF5733"); // Returns a Color object for the color #FF5733
/// Color anotherColor = hexToColor("4287f5"); // Returns a Color object for the color #4287f5
/// ```
Color hexToColor(String code) {
  String hashRemoved = code.replaceAll('#', '');
  String fullHex = '0xFF$hashRemoved';
  return Color(int.parse(fullHex));
}
