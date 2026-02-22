import 'package:flutter/material.dart';
import 'package:edudoro/color.dart';

class FriendListTile extends StatelessWidget {
  final String username;
  final String status;
  final int score;
  final VoidCallback onUnfriend;

  const FriendListTile({
    super.key,
    required this.username,
    required this.status,
    required this.score,
    required this.onUnfriend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Text(username[0].toUpperCase()), // Placeholder for avatar.
          ),
          const SizedBox(width: 16),
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
                Text(
                  status,
                  style: TextStyle(
                    color: status == "Online" ? Colors.green : Colors.red,
                  ),
                ), // Placeholder for friend status.
                Text(
                  "Score: $score",
                  style: TextStyle(color: primary),
                ), // Placeholder for friend score.
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_remove, color: primary),
            onPressed: onUnfriend,
          ),
        ],
      ),
    );
  }
}
