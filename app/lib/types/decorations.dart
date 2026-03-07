/*
File: decorations.dart
Description: This file defines the Decorations class and the DecorationType enum.
Use in Avatar.

Responsibilities:
- Define the DecorationType enum to represent different types of decorations.
- Define the Decorations class to represent a decoration item with its type and detail.

Author: 4KV6
Course: Mobile Application Development Frameworks
*/

/// Defines the types of decorations that can be applied to avatar.
// ignore: constant_identifier_names
enum DecorationType { icon, frame, name_color }

/// The `Decorations` class represents a decoration item that can be applied to an avatar.
///
/// Fields:
/// - type: The type of decoration (icon, frame, or name color).
/// - detail: The specific detail of the decoration (e.g., icon name, frame style, or color code).
///
/// Usage:
/// ```dart
/// final decoration = Decorations(
///   type: DecorationType.icon,
///   detail: "star_icon",
/// );
///
/// final decorationFromJson = Decorations.fromJson(APIResponseBodyJson);
/// ```
/// - The `fromJson` factory constructor allows creating a `Decorations` instance from a JSON map,
/// which is useful for parsing API responses.
class Decorations {
  Decorations({required this.type, required this.detail});

  final DecorationType type;
  final String detail;

  /// Factory constructor to create a `Decorations` instance from a JSON map.
  /// This is typically used to parse API responses into Dart objects.
  factory Decorations.fromJson(Map<String, dynamic> json) {
    return Decorations(
      type: _parseDecorationType(json['type'] as String),
      detail: json['detail'] as String,
    );
  }

  /// Helper method to parse the decoration type from a string.
  static DecorationType _parseDecorationType(String json) {
    switch (json) {
      case 'icon':
        return DecorationType.icon;
      case 'frame':
        return DecorationType.frame;
      case 'name_color':
        return DecorationType.name_color;
      default:
        throw ArgumentError("Unknown decoration type: $json");
    }
  }
}
