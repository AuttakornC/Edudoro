// ignore_for_file: non_constant_identifier_names
/*
File: friends.dart
Description: This file defines the data models for friends and friend requests.
Both class have JSON parsing logic to convert API responses into Dart objects.

Responsibilities:
- Define the FriendsType class to represent a friend list item.
- Define the FriendsRequestType class to represent a friend request item.

Dependencies:
- Decorations class from decorations.dart to represent avatar decorations.

Author: 4KV6
Course: Mobile Application Development Frameworks
*/

import 'package:edudoro/types/decorations.dart';

/// The `FriendsType` class represents a friend list item with details.
///
/// Fields:
/// - friend_account_id: The unique identifier for the friend's account.
/// - username: The username of the friend.
/// - daily_score: The daily score of the friend.
/// - decorations: A list of decorations associated with the friend (optional). //TODO(4KV6): Make it non-optional after API update.
/// - friend_at: The date and time when the friendship was established (optional).
///
/// Usage:
/// ```dart
/// final friend = FriendsType.fromJson(jsonData);
/// ```
/// - The `fromJson` factory constructor allows creating a `FriendsType` instance from a JSON map,
/// which is useful for parsing API responses.
class FriendsType {
  FriendsType({
    required this.friend_account_id,
    required this.username,
    required this.daily_score,
    this.decorations,
    this.friend_at,
  });

  final String friend_account_id;
  final String username;
  final int daily_score;
  final List<Decorations>? decorations;
  final DateTime? friend_at;

  /// Factory constructor to create a `FriendsType` instance from a JSON map.
  /// This is typically used to parse API responses into Dart objects.
  factory FriendsType.fromJson(Map<String, dynamic> json) {
    return FriendsType(
      friend_account_id: json['friend_account_id'] as String,
      username: json['username'] as String,
      daily_score: json['daily_score'] as int,
      decorations: (json['decorations'] ?? [])
          .map((item) => Decorations.fromJson(item))
          .toList(),
      friend_at: DateTime.parse(json['friend_at']),
    );
  }
}

/// The `FriendsRequestType` class represents a friend request item with details.
///
/// Fields:
/// - requester_id: The unique identifier for the account that sent the friend request.
/// - username: The username of the requester.
/// - decorations: A list of decorations associated with the requester (optional).
///
/// Usage:
/// ```dart
/// final friendRequest = FriendsRequestType.fromJson(jsonData);
/// ```
/// - The `fromJson` factory constructor allows creating a `FriendsRequestType` instance from a JSON map,
/// which is useful for parsing API responses.
class FriendsRequestType {
  FriendsRequestType({
    required this.requester_id,
    required this.username,
    this.decorations,
  });

  final String requester_id;
  final String username;
  final List<Decorations>? decorations;

  /// Factory constructor to create a `FriendsRequestType` instance from a JSON map.
  /// This is typically used to parse API responses into Dart objects.
  factory FriendsRequestType.fromJson(Map<String, dynamic> json) {
    return FriendsRequestType(
      requester_id: json['requester_id'] as String,
      username: json['username'] as String,
      decorations: (json['decorations'] as List<dynamic>? ?? [])
          .map((item) => Decorations.fromJson(item))
          .toList(),
    );
  }
}

/// The `FriendsSearchResultType` class represents a search result item when searching for friends.
///
/// Fields:
/// - friend_id: The unique identifier for the friend account found in the search.
/// - username: The username of the friend found in the search.
/// - decorations: A list of decorations associated with the friend (optional).
///
/// Usage:
/// ```dart
/// final searchResult = FriendsSearchResultType.fromJson(jsonData);
/// ```
/// - The `fromJson` factory constructor allows creating a `FriendsSearchResultType` instance from a JSON map,
/// which is useful for parsing API responses when searching for friends.
class FriendsSearchResultType {
  FriendsSearchResultType({
    required this.friend_id,
    required this.username,
    this.decorations,
  });

  final String friend_id;
  final String username;
  final List<Decorations>? decorations;

  /// Factory constructor to create a `FriendsSearchResultType` instance from a JSON map.
  /// This is typically used to parse API responses into Dart objects when searching for friends.
  factory FriendsSearchResultType.fromJson(Map<String, dynamic> json) {
    return FriendsSearchResultType(
      friend_id: json['friend_id'] as String,
      username: json['username'] as String,
      decorations: (json['decorations'] as List<dynamic>? ?? [])
          .map((item) => Decorations.fromJson(item))
          .toList(),
    );
  }
}
