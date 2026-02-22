import 'package:edudoro/color.dart';
import 'package:edudoro/components/util/svgIcon.dart';
import 'package:flutter/material.dart';

class _ShopItem {
  final String id;
  final String label;
  final int price;
  final String? iconSrc;

  const _ShopItem({
    required this.id,
    required this.label,
    required this.price,
    this.iconSrc,
  });
}

final _avatarItems = List.generate(
  9,
  (i) => _ShopItem(
    id: 'avatar_$i',
    label: 'Avatar ${i + 1}',
    price: 100 * (i + 1),
  ),
);

final _frameItems = List.generate(
  9,
  (i) =>
      _ShopItem(id: 'frame_$i', label: 'Frame ${i + 1}', price: 150 * (i + 1)),
);

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int _coins = 9999;

  void _buy(_ShopItem item) {
    if (_coins < item.price) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Not enough coins!")));
      return;
    }
    setState(() => _coins -= item.price);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Purchased ${item.label}!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 45),
            const Text(
              "SHOP",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: primary,
              ),
            ),
            Row(
              children: [
                Text(
                  "$_coins",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: yellow100,
                  ),
                ),
                const SizedBox(width: 4),
                const SVGIcon(
                  src: "assets/icons/CoinIcon.svg",
                  color: yellow100,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: "Avatars"),
              const SizedBox(height: 12),
              _ItemGrid(items: _avatarItems, onBuy: _buy),
              const SizedBox(height: 24),
              _SectionHeader(title: "Frames"),
              const SizedBox(height: 12),
              _ItemGrid(items: _frameItems, onBuy: _buy),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: primary,
          ),
        ),
        const Divider(color: primary, thickness: 4),
      ],
    );
  }
}

class _ItemGrid extends StatelessWidget {
  final List<_ShopItem> items;
  final void Function(_ShopItem) onBuy;

  const _ItemGrid({required this.items, required this.onBuy});

  @override
  Widget build(BuildContext context) {
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
      itemBuilder: (context, index) =>
          _ShopCard(item: items[index], onBuy: onBuy),
    );
  }
}

class _ShopCard extends StatelessWidget {
  final _ShopItem item;
  final void Function(_ShopItem) onBuy;

  const _ShopCard({required this.item, required this.onBuy});

  Future<void> _showConfirmDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
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
                "Are you sure to\nbuy this item?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: primary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text(
                        "Confirm",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primary,
                        side: const BorderSide(color: primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed == true) onBuy(item);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showConfirmDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: item.iconSrc != null
                    ? SVGIcon(src: item.iconSrc!, width: 56, height: 56)
                    : const Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 48,
                          color: primary,
                        ),
                      ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${item.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: yellow100,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const SVGIcon(
                    src: "assets/icons/CoinIcon.svg",
                    color: yellow100,
                    width: 14,
                    height: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
