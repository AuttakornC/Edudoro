import 'dart:convert';
import 'package:edudoro/color.dart';
import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';

class _DecorationItem {
  final String decorationId;
  final String detail;

  _DecorationItem({required this.decorationId, required this.detail});

  factory _DecorationItem.fromJson(Map<String, dynamic> json) =>
      _DecorationItem(
        decorationId: json['decoration_id'] as String,
        detail: json['detail'] as String,
      );
}

class AvatarChangePage extends StatefulWidget {
  const AvatarChangePage({super.key});

  @override
  State<AvatarChangePage> createState() => _AvatarChangePageState();
}

class _AvatarChangePageState extends State<AvatarChangePage> {
  List<_DecorationItem> _icons = [];
  List<_DecorationItem> _frames = [];
  bool _isLoading = false;

  String? _selectedIconId;
  String? _selectedFrameId;

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchOwnedDecorations);
  }

  Future<void> _fetchOwnedDecorations() async {
    setState(() => _isLoading = true);
    try {
      final response = await fetch(
        "/shop/decorations",
        HTTPMethod.get,
        withAuth: true,
      );
      final body = jsonDecode(response.body);
      print(body['data']);
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
        });
      } else {
        toast("Failed to load decorations.");
      }
    } catch (e) {
      toast("Something went wrong. $e");
    }
    setState(() => _isLoading = false);
  }

  Future<void> _save() async {
    if (_selectedIconId == null && _selectedFrameId == null) return;

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
      if (!mounted) return;
      await _showSavedDialog();
    } catch (e) {
      toast("Something went wrong. $e");
    }
  }

  Future<void> _showSavedDialog() async {
    if (!mounted) return;
    toast("Saved successfully!");
    Navigator.of(context).pop();
  }

  Widget _buildPreview(String detail, String assetPrefix) {
    return Image.asset(
      '$assetPrefix/$detail',
      fit: BoxFit.contain,
    );
  }

  Widget _card({
    required _DecorationItem item,
    required bool selected,
    required VoidCallback onTap,
    required String assetPrefix,
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
          child: _buildPreview(item.detail, assetPrefix),
        ),
      ),
    );
  }

  Widget _grid({
    required List<_DecorationItem> items,
    required String? selectedId,
    required Function(String) onSelect,
    required String assetPrefix,
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
    final bool hasSelection =
        _selectedIconId != null || _selectedFrameId != null;

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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}