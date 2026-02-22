import 'package:edudoro/color.dart';
import 'package:flutter/material.dart';

import '../components/ui/friend_list_tile.dart';
import '../components/ui/friend_req_list_tile.dart';

// TODO(4KV6): Implement friend page feature.
// - Show friend list
// - Show friend request list
// - Add friend by username

// mock data for add friend form
var mockUserData = [
  {"id": 1, "username": "Alice", "score": 1500, "status": "Online"},
  {"id": 2, "username": "Bob", "score": 1200, "status": "Offline"},
  {"id": 3, "username": "Charlie", "score": 1800, "status": "Online"},
  {"id": 4, "username": "David", "score": 1100, "status": "Offline"},
  {"id": 5, "username": "Eve", "score": 1300, "status": "Online"},
  {"id": 6, "username": "Frank", "score": 1400, "status": "Offline"},
  {"id": 7, "username": "Grace", "score": 1600, "status": "Online"},
  {"id": 8, "username": "Heidi", "score": 1700, "status": "Offline"},
];

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FRIENDS",
          style: const TextStyle(fontWeight: FontWeight.bold, color: primary),
        ),
      ),
      body: FriendPageView(),
    );
  }
}

class FriendPageView extends StatefulWidget {
  const FriendPageView({super.key});

  @override
  State<StatefulWidget> createState() => _FriendPageView();
}

class _FriendPageView extends State<FriendPageView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [FriendList(), FriendRequestList()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Friends"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Requests",
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => AddFriendForm());
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class FriendList extends StatelessWidget {
  const FriendList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FriendListTile(
            username: "Friend ${index + 1}",
            status: "Online",
            score: index * 100,
            onUnfriend: () {
              // TODO(4KV6): Implement unfriend functionality.
            },
          ),
        );
      },
    );
  }
}

class FriendRequestList extends StatelessWidget {
  const FriendRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // TODO(4KV6): Replace with actual friend request count.
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FriendRequestListTile(
            username: "User ${index + 1}",
            time:
                "2024-06-01 12:00", // TODO(4KV6): Replace with actual request time.
            onAccept: () {
              // TODO(4KV6): Implement accept friend request functionality.
            },
            onReject: () {
              // TODO(4KV6): Implement reject friend request functionality.
            },
          ),
        );
      },
    );
  }
}

class AddFriendForm extends StatefulWidget {
  const AddFriendForm({super.key});

  @override
  State<StatefulWidget> createState() => _AddFriendForm();
}

class _AddFriendForm extends State<AddFriendForm> {
  final TextEditingController _usernameController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isAddButtonDisabled = true;
  int? _selectedUserId;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChanged);
  }

  void _onUsernameChanged() {
    final input = _usernameController.text.trim();
    setState(() {
      if (input.isNotEmpty) {
        // Mock search: filter mockUserData by username contains input (case-insensitive)
        _searchResults = mockUserData
            .where(
              (user) =>
                  (user["username"] as String?)?.toLowerCase().contains(
                    input.toLowerCase(),
                  ) ??
                  false,
            )
            .toList();
      } else {
        _searchResults = [];
      }
    });
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onUsernameChanged);
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Friend"),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_searchResults.isNotEmpty)
              SizedBox(
                height: 120, // Fixed height for the search results list
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    return SizedBox(
                      height: 60,
                      child: ListTile(
                        selectedColor: primary,
                        selected: user["id"] == _selectedUserId,
                        title: Text(user["username"] ?? "Unknown"),
                        subtitle: Text("Score: ${user["score"] ?? 0}"),
                        trailing: Text(user["status"] ?? "Unknown"),
                        onTap: () {
                          setState(() {
                            _selectedUserId = user["id"];
                            _isAddButtonDisabled = false;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isAddButtonDisabled
              ? null
              : () {
                  // TODO(4KV6): Implement add friend functionality.
                  Navigator.of(context).pop();
                },
          child: Text("Add"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancel"),
        ),
      ],
    );
  }
}
