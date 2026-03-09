/*
File: friend_list_tile.dart
Description: This file defines the FriendListTile widget, which is used to display a friend in the friend list.

Responsibilities:
- Display the friend's username and score.
- Provide an option to unfriend the user.

Author: 4KV6
Course: Mobile Application Development Frameworks
*/

import 'package:edudoro/color.dart' as colors;
import 'package:edudoro/types/decorations.dart';
import 'package:flutter/material.dart';
import 'package:edudoro/color.dart';

import 'decoration_display.dart';

/// The `FriendListTile` widget represents a single friend item in the friend list.
/// It displays the friend's username, score, and provides an option to unfriend the user.
///
/// Fields:
/// - username: The username of the friend.
/// - score: The daily score of the friend.
/// - onUnfriend: A callback function that is called when the unfriend button is pressed
/// - avatar: The avatar decoration of the friend. Optional.
/// - frame: The frame decoration of the friend. Optional.
///
/// Usage:
/// ```dart
/// FriendListTile(
///   username: "friend_username",
///   score: 100,
///   onUnfriend: () {
///     // Handle unfriend action
///   },
///   avatar: Decorations(type: DecorationType.avatar, detail: "Avatar1.png"),
///   frame: Decorations(type: DecorationType.frame, detail: "Frame1.png"),
/// );
/// ```
class FriendListTile extends StatelessWidget {
  /// The username of the friend.
  final String username;
  // final String status;
  /// The daily score of the friend.
  final int score;

  /// A callback function that is called when the unfriend button is pressed.
  final VoidCallback onUnfriend;

  /// The avatar decoration of the friend. Optional.
  final Decorations? avatar;

  /// The frame decoration of the friend. Optional.
  final Decorations? frame;

  const FriendListTile({
    super.key,
    required this.username,
    // required this.status,
    required this.score,
    required this.onUnfriend,
    this.avatar,
    this.frame,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // border and background color
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          // Avatar section
          if (avatar != null || frame != null)
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.secondary,
              ),
              child: DecorationDisplay(avatar: avatar, frame: frame, size: 48),
            )
          else
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.secondary,
              ),
              child: Center(
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : "?",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 16),
          // Username and score section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                // Text(
                //   status,
                //   style: TextStyle(
                //     color: status == "Online" ? Colors.green : Colors.red,
                //   ),
                // ),
                Text("Score: $score", style: TextStyle(color: primary)),
              ],
            ),
          ),
          // Unfriend button
          IconButton(
            icon: const Icon(Icons.person_remove, color: primary),
            onPressed: onUnfriend,
          ),
        ],
      ),
    );
  }
}
