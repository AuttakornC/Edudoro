/*
 * File: avatar_change.dart
 * Description: UI screen for selecting and applying owned decorations
 * including avatars, frames, and name colors to the user's profile.
 *
 * Dependencies:
 * - edudoro/app/lib/utils/http.dart (network requests)
 * - edudoro/app/lib/utils/toast.dart (error notifications)
 * - edudoro/app/lib/color.dart (app color constants)
 *
 * Lifecycle:
 * - Created via Navigator from ProfilePage
 * - Fetches owned decorations on init
 * - Disposed when user navigates back
 *
 * Author: Phatcharat Praipanasampan
 * Course: Mobile Application Development Framework
 */

import 'dart:convert';
import 'package:edudoro/color.dart';
import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';

/// Internal model representing a single owned decoration item.
///
/// Fields:
/// - decorationId: unique identifier used when applying the decoration
/// - detail: asset path or hex color string used for rendering
class _DecorationItem {
  final String decorationId;
  final String detail;

  _DecorationItem({required this.decorationId, required this.detail});

  /// Creates a [_DecorationItem] from a JSON map returned by the API.
  factory _DecorationItem.fromJson(Map<String, dynamic> json) =>
      _DecorationItem(
        decorationId: json['decoration_id'] as String,
        detail: json['detail'] as String,
      );
}

/// The [AvatarChangePage] allows the user to browse and select owned
/// decorations (avatars, frames, name colors) to apply to their profile.
///
/// Fields:
/// - icons: list of owned avatar icon decorations
/// - frames: list of owned frame decorations
/// - nameColors: list of owned name color decorations
/// - isLoading: whether decorations are currently being fetched
/// - selectedIconId: decoration_id of the currently selected avatar
/// - selectedFrameId: decoration_id of the currently selected frame
/// - selectedNameColorId: decoration_id of the currently selected name color
///
/// Usage:
/// - Navigated to from ProfilePage via "/avatar_change"
/// - On save, applies selected decorations to the server and returns
class AvatarChangePage extends StatefulWidget {
  const AvatarChangePage({super.key});

  @override
  State<AvatarChangePage> createState() => _AvatarChangePageState();
}

class _AvatarChangePageState extends State<AvatarChangePage> {
  /// List of owned avatar icon decorations.
  List<_DecorationItem> _icons = [];

  /// List of owned frame decorations.
  List<_DecorationItem> _frames = [];

  /// List of owned name color decorations.
  List<_DecorationItem> _nameColors = [];

  /// Whether the decoration data is currently being fetched.
  bool _isLoading = false;

  /// The decoration_id of the currently selected avatar icon.
  String? _selectedIconId;

  /// The decoration_id of the currently selected frame.
  String? _selectedFrameId;

  /// The decoration_id of the currently selected name color.
  String? _selectedNameColorId;

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchOwnedDecorations);
  }

  /// Fetches all owned decorations from [GET /api/v1/shop/decorations].
  ///
  /// Filters items where owned is true for icons, frames, and name colors.
  /// Shows a toast message if the request fails or the server returns an error.
  Future<void> _fetchOwnedDecorations() async {
    setState(() => _isLoading = true);
    try {
      final response = await fetch(
        "/shop/decorations",
        HTTPMethod.get,
        withAuth: true,
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = body['data'];
        setState(() {
          _icons = (data['icons'] as List)
              .where((e) => e['owned'] == true)
              .map((e) => _DecorationItem.fromJson(e as Map<String, dynamic>))
              .toList();
          _frames = (data['frames'] as List)
              .where((e) => e['owned'] == true)
              .map((e) => _DecorationItem.fromJson(e as Map<String, dynamic>))
              .toList();
          _nameColors = (data['name_colors'] as List)
              .where((e) => e['owned'] == true)
              .map((e) => _DecorationItem.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      } else {
        toast("Failed to load decorations.");
      }
    } catch (e) {
      toast("Something went wrong. $e");
    }
    setState(() => _isLoading = false);
  }

  /// Saves the selected decorations by calling [PATCH /api/v1/profile/use] for each.
  ///
  /// Only sends requests for decoration types that have a new selection.
  /// Does nothing if no decoration has been selected.
  ///
  /// Side effects:
  /// - Updates the active icon, frame, or name color on the server
  /// - Shows a toast message on success or failure
  Future<void> _save() async {
    if (_selectedIconId == null &&
        _selectedFrameId == null &&
        _selectedNameColorId == null) return;

    try {
      if (_selectedIconId != null) {
        await fetch(
          "/profile/use",
          HTTPMethod.patch,
          body: {'decoration_id': _selectedIconId},
          withAuth: true,
        );
      }
      if (_selectedFrameId != null) {
        await fetch(
          "/profile/use",
          HTTPMethod.patch,
          body: {'decoration_id': _selectedFrameId},
          withAuth: true,
        );
      }
      if (_selectedNameColorId != null) {
        await fetch(
          "/profile/use",
          HTTPMethod.patch,
          body: {'decoration_id': _selectedNameColorId},
          withAuth: true,
        );
      }
      if (!mounted) return;
      toast("Saved successfully!");
    } catch (e) {
      toast("Something went wrong. $e");
    }
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

  /// Builds a preview widget for a decoration item.
  ///
  /// Parameters:
  /// - [detail]: asset filename or hex color string
  /// - [assetPrefix]: optional asset folder path; if provided renders an image
  ///
  /// Returns an image widget for asset-based decorations,
  /// a colored circle for hex color decorations,
  /// or a fallback icon if neither applies.
  Widget _buildPreview(String detail, {String? assetPrefix}) {
    if (assetPrefix != null) {
      return Image.asset(
        '$assetPrefix/$detail',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.image_outlined,
          size: 48,
          color: primary,
        ),
      );
    }
    if (detail.startsWith('#')) {
      return Center(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _parseHexColor(detail),
            shape: BoxShape.circle,
            border: Border.all(color: primary, width: 2),
          ),
        ),
      );
    }
    return const Center(
      child: Icon(Icons.image_outlined, size: 48, color: primary),
    );
  }

  /// Builds a selectable card widget for a single decoration item.
  ///
  /// Parameters:
  /// - [item]: the decoration item to display
  /// - [selected]: whether this card is currently selected
  /// - [onTap]: callback invoked when the card is tapped
  /// - [assetPrefix]: optional asset folder path passed to [_buildPreview]
  Widget _card({
    required _DecorationItem item,
    required bool selected,
    required VoidCallback onTap,
    String? assetPrefix,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: secondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? primary : Colors.transparent,
            width: 3,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: _buildPreview(item.detail, assetPrefix: assetPrefix),
        ),
      ),
    );
  }

  /// Builds a 3-column grid of selectable decoration cards.
  ///
  /// Parameters:
  /// - [items]: list of decoration items to display
  /// - [selectedId]: decoration_id of the currently selected item
  /// - [onSelect]: callback invoked with the decoration_id when a card is tapped
  /// - [assetPrefix]: optional asset folder path passed to each [_card]
  ///
  /// Shows an empty state message if [items] is empty.
  Widget _grid({
    required List<_DecorationItem> items,
    required String? selectedId,
    required Function(String) onSelect,
    String? assetPrefix,
  }) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            "No items owned yet",
            style: TextStyle(color: primary),
          ),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (_, i) => _card(
        item: items[i],
        selected: selectedId == items[i].decorationId,
        onTap: () => setState(() => onSelect(items[i].decorationId)),
        assetPrefix: assetPrefix,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = _selectedIconId != null ||
        _selectedFrameId != null ||
        _selectedNameColorId != null;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: primary),
        title: const Text(
          "PROFILE",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: primary,
          ),
        ),
        actions: [
          if (hasSelection)
            TextButton(
              onPressed: _save,
              child: const Text(
                "SAVE",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Avatars",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: primary,
                ),
              ),
              const Divider(color: primary, thickness: 4),
              const SizedBox(height: 12),
              _grid(
                items: _icons,
                selectedId: _selectedIconId,
                onSelect: (id) => _selectedIconId = id,
                assetPrefix: 'assets/avatars',
              ),
              const SizedBox(height: 24),
              const Text(
                "Frames",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: primary,
                ),
              ),
              const Divider(color: primary, thickness: 4),
              const SizedBox(height: 12),
              _grid(
                items: _frames,
                selectedId: _selectedFrameId,
                onSelect: (id) => _selectedFrameId = id,
                assetPrefix: 'assets/frames',
              ),
              const SizedBox(height: 24),
              const Text(
                "Name Colors",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: primary,
                ),
              ),
              const Divider(color: primary, thickness: 4),
              const SizedBox(height: 12),
              _grid(
                items: _nameColors,
                selectedId: _selectedNameColorId,
                onSelect: (id) => _selectedNameColorId = id,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}