import 'package:edudoro/color.dart';
import 'package:edudoro/components/ui/confirm_dialog.dart';
import 'package:edudoro/components/util/svgIcon.dart';
import 'package:edudoro/providers/coin_provider.dart';
import 'package:edudoro/providers/shop_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<ShopProvider>().fetchDecorations(),
    );
  }

  Future<void> _handleBuy(ShopDecorationItem item) async {
    final shopProvider = context.read<ShopProvider>();
    final coinProvider = context.read<CoinProvider>();
    final result = await shopProvider.buyDecoration(item.decorationId);
    if (!mounted) return;
    switch (result) {
      case BuyResult.success:
        await coinProvider.refresh();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Purchase successful!")),
        );
      case BuyResult.notEnoughCoins:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Not enough coins!")),
        );
      case BuyResult.alreadyBought:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You already own this item!")),
        );
      case BuyResult.notFound:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Item not found.")),
        );
      case BuyResult.error:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Something went wrong.")),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CoinProvider, ShopProvider>(
      builder: (context, coinProvider, shopProvider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 45),
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
                      "${coinProvider.coin}",
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
            child: shopProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (shopProvider.icons.isNotEmpty) ...[
                          const _SectionHeader(title: "Avatars"),
                          const SizedBox(height: 12),
                          _ItemGrid(
                            items: shopProvider.icons,
                            onBuy: _handleBuy,
                          ),
                          const SizedBox(height: 24),
                        ],
                        if (shopProvider.frames.isNotEmpty) ...[
                          const _SectionHeader(title: "Frames"),
                          const SizedBox(height: 12),
                          _ItemGrid(
                            items: shopProvider.frames,
                            onBuy: _handleBuy,
                          ),
                          const SizedBox(height: 24),
                        ],
                        if (shopProvider.nameColors.isNotEmpty) ...[
                          const _SectionHeader(title: "Name Colors"),
                          const SizedBox(height: 12),
                          _ItemGrid(
                            items: shopProvider.nameColors,
                            onBuy: _handleBuy,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),
          ),
        );
      },
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
  final List<ShopDecorationItem> items;
  final void Function(ShopDecorationItem) onBuy;

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
  final ShopDecorationItem item;
  final void Function(ShopDecorationItem) onBuy;

  const _ShopCard({required this.item, required this.onBuy});

  Future<void> _showConfirmDialog(BuildContext context) async {
    if (item.owned) return;
    final confirmed = await showConfirmDialog(
      context: context,
      message: "Are you sure to\nbuy this item?",
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
                child: _buildPreview(),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: item.owned ? Colors.green : primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: item.owned
                    ? const Text(
                        "Owned",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SVGIcon(
                            src: "assets/icons/CoinIcon.svg",
                            color: yellow100,
                            width: 14,
                            height: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "Buy",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: yellow100,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    // Color code detail (e.g. name_color type)
    if (item.detail.startsWith('#')) {
      final color = _parseHexColor(item.detail);
      return Center(
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: primary, width: 2),
          ),
        ),
      );
    }
    // SVG asset or remote URL
    if (item.detail.endsWith('.svg')) {
      return SVGIcon(src: item.detail, width: 56, height: 56);
    }
    // Fallback
    return const Center(
      child: Icon(Icons.image_outlined, size: 48, color: primary),
    );
  }

  Color _parseHexColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    final value = int.tryParse(
      cleaned.length == 6 ? 'FF$cleaned' : cleaned,
      radix: 16,
    );
    return value != null ? Color(value) : primary;
  }
}

