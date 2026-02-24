import 'package:flutter/material.dart';
import '../color.dart';

class AvatarChangePage extends StatefulWidget {
  const AvatarChangePage({super.key});

  @override
  State<AvatarChangePage> createState() => _AvatarChangePageState();
}

class _AvatarChangePageState extends State<AvatarChangePage> {
  int? selectedAvatar;
  int? selectedFrame;

  Future<void> _showSavedDialog() async {
    await showDialog(
      context: context,
      barrierColor: Colors.black38,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: secondary,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Saved successfully",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: primary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: white,
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.pop(context, {
                    "avatar": selectedAvatar,
                    "frame": selectedFrame,
                  });
                },
                child: const Text("OK"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({
    required bool selected,
    required VoidCallback onTap,
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
        child: const Center(
          child: Icon(
            Icons.image_outlined,
            size: 48,
            color: primary,
          ),
        ),
      ),
    );
  }

  Widget _grid({
    required int count,
    required int? selected,
    required Function(int) onSelect,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (_, i) => _card(
        selected: selected == i,
        onTap: () => setState(() => onSelect(i)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          if (selectedAvatar != null || selectedFrame != null)
            TextButton(
              onPressed: _showSavedDialog,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                count: 9,
                selected: selectedAvatar,
                onSelect: (i) => selectedAvatar = i,
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
                count: 9,
                selected: selectedFrame,
                onSelect: (i) => selectedFrame = i,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}