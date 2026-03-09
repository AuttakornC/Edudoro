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

import 'package:edudoro/color.dart' as colors;
import 'package:edudoro/types/decorations.dart';
import 'package:flutter/material.dart';
import 'package:edudoro/color.dart';

import 'decoration_display.dart';

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

  /// The avatar decoration of the requester. Optional.
  final Decorations? avatar;

  /// The frame decoration of the requester. Optional.
  final Decorations? frame;

  const FriendRequestListTile({
    super.key,
    required this.username,
    // required this.time,
    required this.onAccept,
    required this.onReject,
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
