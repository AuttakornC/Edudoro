/*
File: friend.dart
Description: This file contains the implementation of the FriendPage, 
which allows users to view their friends list, 
manage friend requests, and add new friends. 
It includes the FriendList and FriendRequestList components, 
as well as the AddFriendForm for searching and sending friend requests.

Responsibilities:
- Fetch and display the user's friends list.
- Fetch and display friend requests.
- Allow users to send and manage friend requests.

Author: 4KV6
Course: Mobile Application Development Frameworks
*/

import 'dart:convert';

import 'package:edudoro/color.dart';
import 'package:edudoro/types/decorations.dart';
import 'package:flutter/material.dart';

import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/toast.dart';

import '../components/ui/friend_list_tile.dart';
import '../components/ui/friend_req_list_tile.dart';
import '../components/ui/confirm_dialog.dart';

// Types
import '../types/friends.dart';

// mock data for add friend form
// var mockUserData = [
//   {"id": 1, "username": "Alice5", "score": 1500, "status": "Online"},
//   {"id": 2, "username": "Bob444", "score": 1200, "status": "Offline"},
//   {"id": 3, "username": "Charlie", "score": 1800, "status": "Online"},
//   {"id": 4, "username": "David1", "score": 1100, "status": "Offline"},
//   {"id": 5, "username": "Eve333", "score": 1300, "status": "Online"},
//   {"id": 6, "username": "Frank2", "score": 1400, "status": "Offline"},
//   {"id": 7, "username": "Grace2", "score": 1600, "status": "Online"},
//   {"id": 8, "username": "Heidi2", "score": 1700, "status": "Offline"},
// ];

/// The `FriendPage` widget is the main entry point for the friends feature.
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

/// The `FriendPageView` widget manages the state and logic for the friends page,
/// including fetching friends and friend requests, and handling user interactions.
///
/// It uses an [IndexedStack] to switch between the friends list and friend request list,
/// and a [BottomNavigationBar] for navigation.
///
/// The [FloatingActionButton] is used to open the [AddFriendForm] dialog for adding new friends.
///
/// The [AddFriendForm] is displayed as a dialog when the user taps the floating action button to add a new friend.
///
/// The [FriendList] and [FriendRequestList] components are responsible for displaying the respective lists of friends and friend requests,
/// and handling user interactions such as accepting or rejecting friend requests, and unfriending users.
///
/// The [FriendListTile] and [FriendRequestListTile] components are used to display individual friend and friend request items in the lists, respectively.
/// The page also includes error handling and loading states to provide feedback to the user during API interactions.
class FriendPageView extends StatefulWidget {
  const FriendPageView({super.key});

  @override
  State<StatefulWidget> createState() => _FriendPageView();
}

/// The `_FriendPageView` class is the stateful implementation of the `FriendPageView` widget.
///
/// It manages the state for the friends list, friend requests, loading states, and user interactions such as accepting/rejecting friend requests and adding new friends.
/// Also index of the currently selected tab (friends list or friend requests) is managed here to switch between the two views.
class _FriendPageView extends State<FriendPageView> {
  /// The index of the currently selected tab in the bottom navigation bar.
  int _selectedIndex = 0;

  /// A boolean indicating whether the friends list is currently being loaded.
  bool _isLoadingfriends = true;

  /// A boolean indicating whether the friend requests list is currently being loaded.
  bool _isLoadingFriendRequests = true;

  /// A list of [FriendsType] objects representing the user's friends.
  final List<FriendsType> _friends = [];

  /// A list of [FriendsRequestType] objects representing the user's friend requests.
  final List<FriendsRequestType> _friendRequests = [];

  // Initial fetching of friends and friend requests when the page is first displayed.
  @override
  void initState() {
    super.initState();
    _fetchFriends();
    _fetchFriendRequests();
  }

  /// Fetches the list of friends from the API and updates the state accordingly.
  ///
  /// Handles loading state and error messages to provide feedback to the user.
  ///
  /// On success, it parses the response and updates the `_friends` list with the retrieved data.
  ///
  /// On failure, it displays an error message using the `toast` function.
  ///
  /// Finally, it sets the loading state to false to indicate that the fetching process is complete.
  ///
  /// This method is called in the `initState` to load the friends list when the page is first displayed,
  /// and can be called again to refresh the list after actions such as accepting or rejecting friend requests.
  ///
  /// The method makes a GET request to the "/friends" endpoint, and expects a JSON response containing a list of friends under the "data" key.
  ///
  /// The response is parsed into a list of `FriendsType` objects, which are then stored in the `_friends` state variable for display in the UI.
  Future<void> _fetchFriends() async {
    setState(() {
      _isLoadingfriends = true;
    });
    try {
      final response = await fetch("/friends", HTTPMethod.get, withAuth: true);
      if (response.statusCode == 200) {
        // Parse response and update _friends list.
        final List<dynamic> body = jsonDecode(response.body)['data'] ?? [];
        // print("Raw friends data from API: $body");
        final List<FriendsType> friends = body
            .map((item) => FriendsType.fromJson(item))
            .toList();
        // print("Fetched friends: $friends");
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

  /// Fetches the list of friend requests from the API and updates the state accordingly.
  ///
  /// Handles loading state and error messages to provide feedback to the user.
  ///
  /// On success, it parses the response and updates the `_friendRequests` list with the retrieved data.
  ///
  /// On failure, it displays an error message using the `toast` function.
  ///
  /// Finally, it sets the loading state to false to indicate that the fetching process is complete.
  ///
  /// This method is called in the `initState` to load the friend requests when the page is first displayed,
  /// and can be called again to refresh the list after actions such as accepting or rejecting friend requests.
  ///
  /// The method makes a GET request to the "/friends/requests" endpoint, and expects a JSON response containing a list of friend requests under the "data" key.
  ///
  /// The response is parsed into a list of `FriendsRequestType` objects, which are then stored in the `_friendRequests` state variable for display in the UI.
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
      // Use IndexedStack to switch between friends list and friend requests list based on the selected index.
      // And use FadeThroughPageRoute for smooth transition between the two views.
      body: FadeIndexedStack(
        duration: const Duration(milliseconds: 150),
        index: _selectedIndex,
        children: [
          FriendList(
            friends: _friends,
            isLoading: _isLoadingfriends,
            onUnfriendHandler: () {
              // Refresh both lists after unfriending to reflect changes in friend requests and friends list.
              _fetchFriends();
              _fetchFriendRequests();
            },
            onRefreshFriends: _fetchFriends,
          ),
          FriendRequestList(
            friendRequests: _friendRequests,
            isLoading: _isLoadingFriendRequests,
            onRequestHandled: () {
              // Refresh both lists after handling a friend request to reflect changes in friend requests and friends list.
              _fetchFriends();
              _fetchFriendRequests();
            },
            onRefreshFriendRequests: _fetchFriendRequests,
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

/// The `FriendList` widget displays the list of friends, and the [FriendRequestList] widget displays the list of friend requests.
/// Both components handle loading states and display appropriate messages when the lists are empty.
///
/// Fields:
/// friends: A list of [FriendsType] objects representing the user's friends.
/// isLoading: A boolean indicating whether the friends list is currently being loaded.
/// onUnfriendHandler: A callback function that is called when a user is unfriended,
/// allowing the parent widget to refresh the lists.
/// onRefreshFriends: A callback function that is called to refresh the friends list when user pulls to refresh,
/// allowing the parent widget to fetch the latest data from the API.
class FriendList extends StatelessWidget {
  /// A list of [FriendsType] objects representing the user's friends.
  final List<FriendsType> friends;

  /// A boolean indicating whether the friends list is currently being loaded.
  final bool isLoading;

  /// A callback function that is called when a user is unfriended, allowing the parent widget to refresh the lists.
  final void Function() onUnfriendHandler;

  /// A callback function that is called to refresh the friends list when user pulls to refresh, allowing the parent widget to fetch the latest data from the API.
  final Future<void> Function() onRefreshFriends;

  const FriendList({
    super.key,
    required this.friends,
    required this.isLoading,
    required this.onUnfriendHandler,
    required this.onRefreshFriends,
  });

  /// Unfriends a user by sending a DELETE request to the API with the friend's account ID.
  Future<void> _unfriend(String friendAccountId) async {
    try {
      final response = await fetch(
        "/friends/$friendAccountId",
        HTTPMethod.delete,
        withAuth: true,
      );

      if (response.statusCode == 200) {
        // successfully unfriended, show success message.
        toast("Unfriended successfully!");
        // Call the onUnfriendHandler callback to refresh the lists.
        onUnfriendHandler();
      } else {
        // failed to unfriend, show error message with details from API response.
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        toast("Failed to unfriend: ${response.statusCode}\n$errorMessage");
      }
    } catch (e) {
      toast("Failed to unfriend: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle loading state
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Handle empty state
    if (friends.isEmpty && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No friends yet.",
              style: TextStyle(fontSize: 16, color: secondary),
            ),
            SizedBox(height: 8),
            ElevatedButton(onPressed: onRefreshFriends, child: Text("Refresh")),
          ],
        ),
      );
    }

    // Display the list of friends with pull-to-refresh functionality. Each friend item includes an option to unfriend,
    // which triggers a confirmation dialog before proceeding with the unfriending action.
    return RefreshIndicator(
      onRefresh: onRefreshFriends,
      notificationPredicate: (notification) {
        // Only trigger refresh when the user is at the top of the list.
        return notification.metrics.pixels ==
            notification.metrics.minScrollExtent;
      },
      child: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FriendListTile(
              username: friends[index].username,
              // status: "Online",
              score: friends[index].daily_score,
              avatar: friends[index].decorations
                  ?.where((d) => d.type == DecorationType.icon)
                  .firstOrNull,
              frame: friends[index].decorations
                  ?.where((d) => d.type == DecorationType.frame)
                  .firstOrNull,
              usernameColor: friends[index].decorations
                  ?.where((d) => d.type == DecorationType.name_color)
                  .firstOrNull,
              onUnfriend: () async {
                final bool confirmed =
                    await showConfirmDialog(
                      context: context,
                      message:
                          "Are you sure you want to unfriend ${friends[index].username}?",
                      confirmLabel: "Unfriend",
                      cancelLabel: "Cancel",
                    ) ??
                    false;
                if (confirmed) {
                  _unfriend(friends[index].friend_account_id);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

/// The `FriendRequestList` widget displays the list of friend requests, and allows users to accept or reject requests.
/// It also handles loading states and displays appropriate messages when the list is empty.
///
/// Fields:
/// friendRequests: A list of [FriendsRequestType] objects representing the user's friend requests.
/// isLoading: A boolean indicating whether the friend requests list is currently being loaded.
/// onRequestHandled: A callback function that is called after a friend request is accepted or rejected,
/// allowing the parent widget to refresh the lists.
/// onRefreshFriendRequests: A callback function that is called to refresh the friend requests list when user pulls to refresh,
/// allowing the parent widget to fetch the latest data from the API.
class FriendRequestList extends StatelessWidget {
  /// A list of [FriendsRequestType] objects representing the user's friend requests.
  final List<FriendsRequestType> friendRequests;

  /// A boolean indicating whether the friend requests list is currently being loaded.
  final bool isLoading;

  /// A callback function that is called after a friend request is accepted or rejected,
  /// allowing the parent widget to refresh the lists.
  final VoidCallback? onRequestHandled;

  /// A callback function that is called to refresh the friend requests list when user pulls to refresh, allowing the parent widget to fetch the latest data from the API.
  final Future<void> Function() onRefreshFriendRequests;

  const FriendRequestList({
    super.key,
    required this.friendRequests,
    required this.isLoading,
    required this.onRequestHandled,
    required this.onRefreshFriendRequests,
  });

  /// Accepts a friend request by sending a PATCH request to the API with the requester's ID.
  ///
  /// On success, it displays a success message and calls the [onRequestHandled] callback to refresh the lists.
  ///
  /// On failure, it displays an error message with details from the API response.
  ///
  /// The method makes a PATCH request to the "/friends/request" endpoint, with the requester's ID in the request body.
  ///
  /// The API is expected to return a 200 status code on success, and may return error messages in the response body on failure.
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
        // successfully accepted friend request, refresh lists and show success message.
        toast("Friend request accepted!");
        onRequestHandled?.call();
      } else {
        // failed to accept friend request, show error message with details from API response.
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

  /// Rejects a friend request by sending a DELETE request to the API with the requester's ID.
  ///
  /// On success, it displays a success message and calls the [onRequestHandled] callback to refresh the lists.
  ///
  /// On failure, it displays an error message with details from the API response.
  ///
  /// The method makes a DELETE request to the "/friends/request/{requesterId}" endpoint, where `{requesterId}` is the ID of the requester.
  ///
  /// The API is expected to return a 200 status code on success, and may return error messages in the response body on failure.
  Future<void> _rejectFriendRequest(String requesterId) async {
    try {
      final response = await fetch(
        "/friends/request/$requesterId",
        HTTPMethod.delete,
        withAuth: true,
      );

      if (response.statusCode == 200) {
        // successfully rejected friend request, refresh lists and show success message.
        toast("Friend request rejected!");
        onRequestHandled?.call();
      } else {
        // failed to reject friend request, show error message with details from API response.
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
    // Handle loading state
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Handle empty state
    if (friendRequests.isEmpty && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No friend requests.",
              style: TextStyle(fontSize: 16, color: secondary),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: onRefreshFriendRequests,
              child: Text("Refresh"),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefreshFriendRequests,
      notificationPredicate: (notification) {
        // Only trigger refresh when the user is at the top of the list.
        return notification.metrics.pixels ==
            notification.metrics.minScrollExtent;
      },
      child: ListView.builder(
        itemCount: friendRequests.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: FriendRequestListTile(
              username: friendRequests[index].username,
              // time:
              //     "2024-06-01 12:00",
              avatar: friendRequests[index].decorations
                  ?.where((d) => d.type == DecorationType.icon)
                  .firstOrNull,
              frame: friendRequests[index].decorations
                  ?.where((d) => d.type == DecorationType.frame)
                  .firstOrNull,
              usernameColor: friendRequests[index].decorations
                  ?.where((d) => d.type == DecorationType.name_color)
                  .firstOrNull,
              onAccept: () {
                toast("Accepting friend request...");
                _acceptFriendRequest(friendRequests[index].requester_id);
              },
              onReject: () async {
                final bool confirmed =
                    await showConfirmDialog(
                      context: context,
                      message:
                          "Are you sure you want to reject the friend request from ${friendRequests[index].username}?",
                      confirmLabel: "Reject",
                      cancelLabel: "Cancel",
                    ) ??
                    false;
                if (confirmed) {
                  _rejectFriendRequest(friendRequests[index].requester_id);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

/// The `AddFriendForm` widget is a dialog that allows users to search for other users by username and send friend requests.
/// It includes a text field for entering the username, and displays search results in a list below the text field.
///
/// Users can tap on a search result to select it, and then tap the "Add" button to send a friend request to the selected user.
/// The form also handles loading states and displays appropriate messages when no users are found or when the search input is invalid.
class AddFriendForm extends StatefulWidget {
  const AddFriendForm({super.key});

  @override
  State<StatefulWidget> createState() => _AddFriendForm();
}

/// The `_AddFriendForm` class is the stateful implementation of the `AddFriendForm` widget.
///
/// It manages the state for the search input, search results, selected user, and loading states during the search and friend request sending processes.
class _AddFriendForm extends State<AddFriendForm> {
  /// A controller for the username input text field.
  final TextEditingController _usernameController = TextEditingController();

  /// A list of [FriendsSearchResultType] objects representing the search results for users matching the input username.
  List<FriendsSearchResultType> _searchResults = [];

  /// A boolean indicating whether the "Add" button is currently disabled (i.e., no user is selected).
  bool _isAddButtonDisabled = true;

  /// The ID of the currently selected user from the search results, or null if no user is selected.
  String? _selectedUserId;

  /// The username of the currently selected user from the search results, or null if no user is selected.
  String? _selectedUsername;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_onUsernameChanged);
  }

  /// This method is called whenever the text in the username input field changes.
  ///
  /// It performs a search for users matching the input username by making a GET request to the "/friends/request" endpoint with the search parameter.
  /// The search results are then displayed in a list below the input field.
  ///
  /// If the input is empty or too short, it clears the search results and disables the "Add" button.
  ///
  /// On success, it updates the `_searchResults` list with the retrieved users.
  ///
  /// On failure, it displays an error message using the `toast` function and clears the search results.
  ///
  /// On a 404 status code response, it clears the search results to indicate that no users were found.
  ///
  /// The method expects the API to return a JSON response containing a list of users under the "data" key, which is parsed into a list of `FriendsSearchResultType` objects for display in the UI.
  Future<void> _onUsernameChanged() async {
    final input = _usernameController.text.trim();
    // If the input is empty or too short, clear search results and disable the "Add" button.
    if (input.isEmpty || input.length <= 1) {
      setState(() {
        _searchResults = [];
        _isAddButtonDisabled = true;
      });
      return;
    }
    final response = await fetch(
      "/friends/request?search=$input",
      HTTPMethod.get,
      withAuth: true,
    );
    // Handle response and update search results
    if (response.statusCode == 200) {
      // successfully retrieved search results, parse response and update _searchResults list.
      final List<dynamic> body = jsonDecode(response.body)['data'] ?? [];
      final List<FriendsSearchResultType> searchResults = body
          .map((item) => FriendsSearchResultType.fromJson(item))
          .toList();
      setState(() {
        _searchResults = searchResults;
      });
    } else if (response.statusCode == 404) {
      // No users found, clear search results.
      setState(() {
        _searchResults = [];
      });
    } else {
      // failed to retrieve search results, show error message with details from API response and clear search results.
      final errorMessage =
          jsonDecode(response.body)['message'] ?? 'Unknown error';
      toast("Failed to search users: ${response.statusCode}\n$errorMessage");
      setState(() {
        _searchResults = [];
        _isAddButtonDisabled = true;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.removeListener(_onUsernameChanged);
    _usernameController.dispose();
    super.dispose();
  }

  /// This method is called when the user taps the "Add" button to send a friend request to the selected user.
  ///
  /// It sends a POST request to the "/friends/request" endpoint with the selected user's ID in the request body.
  ///
  /// On success, it displays a success message and closes the dialog.
  ///
  /// On failure, it displays an error message with details from the API response.
  ///
  /// On a 409 status code response, it indicates that a friend request has already been sent to the selected user, and displays an appropriate message.
  ///
  /// The method expects the API to return a 200 status code on success, and may return error messages in the response body on failure.
  Future<void> _addFriend() async {
    if (_selectedUserId == null) return;

    try {
      final response = await fetch(
        "/friends/request",
        HTTPMethod.post,
        withAuth: true,
        headers: {"Content-Type": "application/json"},
        body: {"friend_id": _selectedUserId},
      );

      if (response.statusCode == 200) {
        // successfully sent friend request, show success message and close dialog.
        toast("Friend request sent to $_selectedUsername!");
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else if (response.statusCode == 409) {
        // A friend request has already been sent to the selected user, show appropriate message.
        // final selectedFriend = _searchResults.firstWhere(
        //   (user) => user.friend_id == _selectedUserId,
        // );
        // if (selectedFriend.friend_at != null) {
        //   toast("You are already friends with $_selectedUsername.");
        // } else {
        //   toast(
        //     "A friend request has already been sent to $_selectedUsername.",
        //   );
        // }
        toast("A friend request has already been sent to $_selectedUsername.");
      } else if (response.statusCode == 404) {
        // The selected user was not found, show appropriate message and clear search results.
        toast("User not found. Please try searching again.");
        setState(() {
          _searchResults = [];
          _isAddButtonDisabled = true;
        });
      } else if (response.statusCode == 400) {
        // Bad request, likely due to invalid input, show appropriate message.
        final errorMessage =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        toast("Failed to send friend request: $errorMessage");
      } else {
        // failed to send friend request, show error message with details from API response.
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
            // Display search results if available.
            if (_searchResults.isNotEmpty)
              SizedBox(
                height:
                    // Limit height to show up to 3 results without scrolling, otherwise make it scrollable.
                    60 *
                    (_searchResults.length.toDouble() <= 3
                        ? _searchResults.length.toDouble()
                        : 3),
                child: ListView.builder(
                  controller: ScrollController(
                    initialScrollOffset: 0,
                    keepScrollOffset: true,
                  ),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    return SizedBox(
                      height: 60,
                      child: ListTile(
                        selectedColor: primary,
                        selected: user.friend_id == _selectedUserId,
                        title: Text(user.username),
                        // subtitle: Text("Score: ${user.daily_score}"),
                        trailing: user.friend_id == _selectedUserId
                            ? Icon(Icons.check, color: primary)
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedUserId = user.friend_id;
                            _selectedUsername = user.username;
                            _isAddButtonDisabled = false;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            // Display messages for empty or invalid input states.
            if (_searchResults.isEmpty &&
                _usernameController.text.trim().isNotEmpty &&
                _usernameController.text.trim().length >= 2)
              SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    "No users found with that username.",
                    style: TextStyle(color: primary),
                  ),
                ),
              ),
            // Display message when input is empty or too short.
            if (_usernameController.text.trim().isEmpty ||
                _usernameController.text.trim().length <= 1)
              SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    "Please enter a username to search.\n(At least 2 characters)",
                    style: TextStyle(color: primary),
                  ),
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

/// The `FadeIndexedStack` widget is a custom implementation of an IndexedStack that adds a fade transition effect when switching between child widgets.
///
/// It takes an `index` to determine which child to display, a list of `children` widgets, and a `duration` for the fade transition effect.
/// When the `index` changes, the widget will fade out the currently visible child and fade in the new child corresponding to the new index.
///
/// Fields:
/// - index: The index of the child widget to display.
/// - children: A list of child widgets to be displayed based on the index.
/// - duration: The duration of the fade transition effect when switching between child widgets (default is 300 milliseconds).
///
/// Usage:
/// ```dart
/// FadeIndexedStack(
///   index: _selectedIndex,
///   children: [
///     FriendList(...),
///     FriendRequestList(...),
///   ],
///   duration: Duration(milliseconds: 150),
/// );
/// ```
class FadeIndexedStack extends StatelessWidget {
  /// The index of the child widget to display.
  final int index;

  /// A list of child widgets to be displayed based on the index.
  final List<Widget> children;

  /// The duration of the fade transition effect when switching between child widgets (default is 300 milliseconds).
  final Duration duration;

  const FadeIndexedStack({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(children.length, (i) {
        // Each child is wrapped in an AnimatedOpacity widget to create the fade effect.
        return AnimatedOpacity(
          opacity: i == index ? 1.0 : 0.0,
          duration: duration,
          child: IgnorePointer(ignoring: i != index, child: children[i]),
        );
      }),
    );
  }
}
