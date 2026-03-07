/*
File: friend_list_tile.dart
Description: This file defines the FriendListTile widget, which is used to display a friend in the friend list.

Responsibilities:
- Display the friend's username and score.
- Provide an option to unfriend the user.

Author: 4KV6
Course: Mobile Application Development Frameworks
*/

import 'package:flutter/material.dart';
import 'package:edudoro/color.dart';

/// The `FriendListTile` widget represents a single friend item in the friend list.
/// It displays the friend's username, score, and provides an option to unfriend the user.
///
/// Fields:
/// - username: The username of the friend.
/// - score: The daily score of the friend.
/// - onUnfriend: A callback function that is called when the unfriend button is pressed
///
/// Usage:
/// ```dart
/// FriendListTile(
///   username: "friend_username",
///   score: 100,
///   onUnfriend: () {
///     // Handle unfriend action
///   },
/// );
/// ```
class FriendListTile extends StatelessWidget {
  final String username;
  // final String status;
  final int score;
  final VoidCallback onUnfriend;

  const FriendListTile({
    super.key,
    required this.username,
    // required this.status,
    required this.score,
    required this.onUnfriend,
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
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Text(username[0].toUpperCase()), // Placeholder for avatar.
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
