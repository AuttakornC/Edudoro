/*
File: friend_req_list_tile.dart
Description: This file defines the FriendRequestListTile widget, 
which is used to display a friend request in the friend request list.

Responsibilities:
- Display the requester's username and the time of the request.
- Provide options to accept or reject the friend request.

Author: 4KV6
Course: Mobile Application Development Frameworks
*/

import 'package:flutter/material.dart';
import 'package:edudoro/color.dart';

/// The `FriendRequestListTile` widget represents a single friend request item in the friend request list.
/// It displays the requester's username, the time of the request,
/// and provides options to accept or reject the friend request.
///
/// Fields:
/// - username: The username of the requester.
/// - onAccept: A callback function that is called when the accept button is pressed.
/// - onReject: A callback function that is called when the reject button is pressed.
///
/// Usage:
/// ```dart
/// FriendRequestListTile(
///   username: "requester_username",
///   onAccept: () {
///     // Handle accept action
///   },
///   onReject: () {
///     // Handle reject action
///   },
/// );
/// ```
class FriendRequestListTile extends StatelessWidget {
  /// The username of the requester.
  final String username;
  // final String time;
  /// A callback function that is called when the accept button is pressed.
  final VoidCallback onAccept;

  /// A callback function that is called when the reject button is pressed.
  final VoidCallback onReject;

  const FriendRequestListTile({
    super.key,
    required this.username,
    // required this.time,
    required this.onAccept,
    required this.onReject,
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
          // Username section
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
                // Text("Requested at\n$time"),
              ],
            ),
          ),
          // Accept and reject buttons
          IconButton(
            icon: const Icon(Icons.check, color: primary),
            onPressed: onAccept,
          ),
          IconButton(
            icon: const Icon(Icons.close, color: primary),
            onPressed: onReject,
          ),
        ],
      ),
    );
  }
}
