import 'dart:convert';

import 'package:edudoro/color.dart';
import 'package:flutter/material.dart';

import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/toast.dart';

import '../components/ui/friend_list_tile.dart';
import '../components/ui/friend_req_list_tile.dart';

// Types
import '../types/friends.dart';

// TODO(4KV6): Implement friend page feature.
// - Show friend list
// - Show friend request list
// - Add friend by username

// mock data for add friend form
var mockUserData = [
  {"id": 1, "username": "Alice5", "score": 1500, "status": "Online"},
  {"id": 2, "username": "Bob444", "score": 1200, "status": "Offline"},
  {"id": 3, "username": "Charlie", "score": 1800, "status": "Online"},
  {"id": 4, "username": "David1", "score": 1100, "status": "Offline"},
  {"id": 5, "username": "Eve333", "score": 1300, "status": "Online"},
  {"id": 6, "username": "Frank2", "score": 1400, "status": "Offline"},
  {"id": 7, "username": "Grace2", "score": 1600, "status": "Online"},
  {"id": 8, "username": "Heidi2", "score": 1700, "status": "Offline"},
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
  bool _isLoadingfriends = true;
  bool _isLoadingFriendRequests = true;

  final List<FriendsType> _friends = [];
  final List<FriendsRequestType> _friendRequests = [];

  @override
  void initState() {
    super.initState();
    _fetchFriends();
    _fetchFriendRequests();
  }

  Future<void> _fetchFriends() async {
    setState(() {
      _isLoadingfriends = true;
    });
    try {
      final response = await fetch("/friends", HTTPMethod.get, withAuth: true);
      if (response.statusCode == 200) {
        // Parse response and update _friends list.
        final List<dynamic> body = jsonDecode(response.body)['data'] ?? [];
        final List<FriendsType> friends = body
            .map((item) => FriendsType.fromJson(item))
            .toList();
        setState(() {
          _friends.clear();
          _friends.addAll(friends);
        });
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        toast("Failed to load friends: ${response.statusCode}\n$errorMessage");
      }
    } catch (e) {
      toast("Failed to load friends: $e");
    }
    setState(() {
      _isLoadingfriends = false;
    });
  }

  Future<void> _fetchFriendRequests() async {
    setState(() {
      _isLoadingFriendRequests = true;
    });
    try {
      final response = await fetch(
        "/friends/requests",
        HTTPMethod.get,
        withAuth: true,
      );
      if (response.statusCode == 200) {
        // Parse response and update _friendRequests list.
        final List<dynamic> body = jsonDecode(response.body)['data'] ?? [];
        print("Friend requests response body: $body");
        final List<FriendsRequestType> friendRequests = body
            .map((item) => FriendsRequestType.fromJson(item))
            .toList();
        setState(() {
          _friendRequests.clear();
          _friendRequests.addAll(friendRequests);
        });
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        toast(
          "Failed to load friend requests: ${response.statusCode}\n$errorMessage",
        );
      }
    } catch (e) {
      toast("Failed to load friend requests: $e");
    }
    setState(() {
      _isLoadingFriendRequests = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          FriendList(friends: _friends, isLoading: _isLoadingfriends),
          FriendRequestList(
            friendRequests: _friendRequests,
            isLoading: _isLoadingFriendRequests,
            onRequestHandled: () {
              _fetchFriends();
              _fetchFriendRequests();
            },
          ),
        ],
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
  final List<FriendsType> friends;
  final bool isLoading;

  const FriendList({super.key, required this.friends, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (friends.isEmpty && !isLoading) {
      return Center(
        child: Text(
          "No friends yet. Add some friends to see them here!",
          style: TextStyle(fontSize: 16, color: secondary),
        ),
      );
    }

    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FriendListTile(
            username: friends[index].username,
            status: "Online",
            score: friends[index].daily_score,
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
  final List<FriendsRequestType> friendRequests;
  final bool isLoading;
  final VoidCallback? onRequestHandled;

  const FriendRequestList({
    super.key,
    required this.friendRequests,
    required this.isLoading,
    required this.onRequestHandled,
  });

  Future<void> _acceptFriendRequest(String requesterId) async {
    try {
      final response = await fetch(
        "/friends/request",
        HTTPMethod.patch,
        withAuth: true,
        headers: {"Content-Type": "application/json"},
        body: {"requester_id": requesterId},
      );

      if (response.statusCode == 200) {
        toast("Friend request accepted!");
        onRequestHandled?.call();
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        toast(
          "Failed to accept friend request: ${response.statusCode}\n$errorMessage",
        );
      }
    } catch (e) {
      toast("Failed to accept friend request: $e");
    }
  }

  Future<void> _rejectFriendRequest(String requesterId) async {
    try {
      final response = await fetch(
        "/friends/request/$requesterId",
        HTTPMethod.delete,
        withAuth: true,
      );

      if (response.statusCode == 200) {
        toast("Friend request rejected!");
        onRequestHandled?.call();
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        toast(
          "Failed to reject friend request: ${response.statusCode}\n$errorMessage",
        );
      }
    } catch (e) {
      toast("Failed to reject friend request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (friendRequests.isEmpty && !isLoading) {
      return Center(
        child: Text(
          "No friend requests yet.",
          style: TextStyle(fontSize: 16, color: secondary),
        ),
      );
    }

    return ListView.builder(
      itemCount: friendRequests.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FriendRequestListTile(
            username: friendRequests[index].username,
            time:
                "2024-06-01 12:00", // TODO(4KV6): Replace with actual request time.
            onAccept: () {
              _acceptFriendRequest(friendRequests[index].requester_id);
            },
            onReject: () {
              _rejectFriendRequest(friendRequests[index].requester_id);
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
  String? _selectedUsername;

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

  Future<void> _addFriend() async {
    if (_selectedUserId == null) return;

    try {
      final response = await fetch(
        "/friends/request",
        HTTPMethod.post,
        withAuth: true,
        headers: {"Content-Type": "application/json"},
        body: {"username": _selectedUsername},
      );

      if (response.statusCode == 200) {
        toast("Friend request sent to $_selectedUsername!");
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        toast(
          "Failed to send friend request: ${response.statusCode}\n$errorMessage",
        );
      }
    } catch (e) {
      toast("Failed to send friend request: $e");
    }
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
                            _selectedUsername = user["username"];
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
                  _addFriend();
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
