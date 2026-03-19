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
enum DecorationType {
  /// The icon decoration type allows users to customize the icon displayed on their avatar, such as a badge or symbol.
  icon,

  /// The frame decoration type allows users to customize the border or frame around their avatar image.
  frame,

  /// The name color decoration type allows users to customize the color of their username displayed in the app.
  // ignore: constant_identifier_names
  name_color,
}

/// The `Decorations` class represents a decoration item that can be applied to an avatar.
///
/// Fields:
/// - type: The type of decoration (icon, frame, or name color).
/// - detail: The specific detail of the decoration (e.g., icon name, frame style, or color code).
///
/// Usage:
/// - The [fromJson] factory constructor allows creating a `Decorations` instance from a JSON map,
/// which is useful for parsing API responses.
class Decorations {
  Decorations({required this.type, required this.detail});

  /// The type of decoration (icon, frame, or name color) represented by the [DecorationType] enum.
  final DecorationType type;

  /// The specific detail of the decoration (e.g., icon name, frame style, or color code).
  final String detail;

  /// Factory constructor to create a `Decorations` instance from a JSON map.
  /// This is typically used to parse API responses into Dart objects.
  ///
  /// The method takes a JSON map as input and extracts the relevant fields to create an instance of [Decorations].
  /// It also includes error handling to ensure that the required fields are present and correctly typed in the JSON input. If the JSON structure does not match the expected format, it may throw an error during parsing.
  ///
  /// Usage:
  /// ```dart
  /// final decoration = Decorations.fromJson(jsonData);
  /// ```
  factory Decorations.fromJson(Map<String, dynamic> json) {
    return Decorations(
      type: _parseDecorationType(json['type'] as String),
      detail: json['detail'] as String,
    );
  }

  /// Helper method to parse the decoration type from a string.
  ///
  /// Throws an [ArgumentError] if the decoration type is unknown.
  /// This method is used internally by the [fromJson] factory constructor to convert the string representation of the decoration type into the corresponding [DecorationType] enum value.
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
