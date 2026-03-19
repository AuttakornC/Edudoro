/*
 * File: profile.dart
 * Description: UI screen for displaying the authenticated user's profile,
 * including avatar, username, and email fetched from the backend API.
 *
 * Dependencies:
 * - flutter_secure_storage (JWT token management)
 * - edudoro/app/lib/utils/http.dart (network requests)
 * - edudoro/app/lib/utils/toast.dart (error notifications)
 * - edudoro/app/lib/components/ui/decoration_display.dart (avatar/frame rendering)
 * - edudoro/app/lib/types/decorations.dart (Decorations model)
 *
 * Lifecycle:
 * - Created via Navigator
 * - Fetches user data on init
 * - Disposed when user navigates away
 *
 * Author: Phatcharat Praipanasampan
 * Course: Mobile Application Development Framework
 */

import 'package:edudoro/color.dart';
import 'package:edudoro/components/ui/decoration_display.dart';
import 'package:edudoro/types/decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/toast.dart';

/// The [ProfilePage] displays the current user's avatar, username, and email.
///
/// Fields:
/// - username: display name of the authenticated user
/// - email: email address of the authenticated user
/// - avatar: currently equipped avatar icon decoration
/// - frame: currently equipped frame decoration
/// - nameColor: color applied to the username text
/// - isLoading: whether profile data is being fetched
///
/// Usage:
/// - Navigated to from the main bottom navigation bar
/// - Supports logout which clears JWT token and redirects to sign-in
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  /// The authenticated user's display name.
  String _username = '';

  /// The authenticated user's email address.
  String _email = '';

  /// Currently equipped avatar decoration.
  Decorations? _avatar;

  /// Currently equipped frame decoration.
  Decorations? _frame;

  /// Currently equipped name color.
  Color? _nameColor;

  /// Whether the profile data is currently being fetched.
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadUserInfo);
  }

  /// Converts a hex color string (e.g. "#FF0000" or "FF0000") to a [Color].
  /// Returns [primary] if parsing fails.
  Color _parseHexColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    final value = int.tryParse(
      cleaned.length == 6 ? 'FF$cleaned' : cleaned,
      radix: 16,
    );
    return value != null ? Color(value) : primary;
  }

  /// Fetches the current user's profile from [GET /api/v1/profile].
  ///
  /// This method performs a network request and may take time to complete.
  /// Shows a toast message if the request fails or the server returns an error.
  Future<void> _loadUserInfo() async {
    setState(() => _isLoading = true);
    try {
      final response = await fetch(
        "/profile",
        HTTPMethod.get,
        withAuth: true,
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = body['data'] as Map<String, dynamic>;
        final decorations = (data['decorations'] as List<dynamic>? ?? []);
        setState(() {
          _username = data['username'] as String? ?? '';
          _email = data['email'] as String? ?? '';
          _avatar = decorations
              .cast<Map<String, dynamic>>()
              .where((d) => d['type'] == 'icon')
              .map((d) => Decorations(type: DecorationType.icon, detail: d['detail'] as String))
              .firstOrNull;
          _frame = decorations
              .cast<Map<String, dynamic>>()
              .where((d) => d['type'] == 'frame')
              .map((d) => Decorations(type: DecorationType.frame, detail: d['detail'] as String))
              .firstOrNull;
          _nameColor = decorations
              .cast<Map<String, dynamic>>()
              .where((d) => d['type'] == 'name_color')
              .map((d) => _parseHexColor(d['detail'] as String))
              .firstOrNull;
        });
      }
    } catch (e) {
      toast("Something went wrong. $e");
    }
    setState(() => _isLoading = false);
  }

  /// Logs the user out and clears all local session data.
  ///
  /// Parameters:
  /// - [context]: used to perform navigation after logout
  ///
  /// Side effects:
  /// - Removes JWT token from secure storage
  /// - Navigates to sign-in page
  Future<void> _logout(BuildContext context) async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'jwt_token');
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/sign_in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PROFILE",
          style: TextStyle(fontWeight: FontWeight.bold, color: primary),
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            color: primary,
            tooltip: "Logout",
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 60),

                Container(
                  width: 129,
                  height: 129,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.secondary,
                  ),
                  child: DecorationDisplay(
                    avatar: _avatar,
                    frame: _frame,
                    size: 129,
                  ),
                ),

                const SizedBox(height: 10),

                InkWell(
                  onTap: () async {
                    await Navigator.of(context).pushNamed("/avatar_change");
                    if (mounted) _loadUserInfo();
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                      decorationColor: colors.onPrimary,
                      decorationThickness: 2,
                      fontWeight: FontWeight.bold,
                      color: colors.onPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                  _username.isEmpty ? '-' : _username,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _nameColor ?? colors.primary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  _email.isEmpty ? '-' : _email,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}