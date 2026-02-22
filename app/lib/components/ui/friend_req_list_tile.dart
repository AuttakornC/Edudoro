import 'package:flutter/material.dart';
import 'package:edudoro/color.dart';

class FriendRequestListTile extends StatelessWidget {
  final String username;
  final String time;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const FriendRequestListTile({
    Key? key,
    required this.username,
    required this.time,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

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
                Text("Requested at\n$time"), // Placeholder for request time.
              ],
            ),
          ),
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
