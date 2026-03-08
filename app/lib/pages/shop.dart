import 'dart:convert';

import 'package:edudoro/color.dart';
import 'package:edudoro/components/ui/confirm_dialog.dart';
import 'package:edudoro/components/util/svgIcon.dart';
import 'package:edudoro/providers/coin_provider.dart';
import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _BuyResult { success, notEnoughCoins, alreadyBought, notFound, error }

class _ShopItem {
  final String decorationId;
  final String detail;
  final int price;
  bool owned;

  _ShopItem({
    required this.decorationId,
    required this.detail,
    required this.price,
    required this.owned,
  });

  factory _ShopItem.fromJson(Map<String, dynamic> json) => _ShopItem(
        decorationId: json['decoration_id'] as String,
        detail: json['detail'] as String,
        price: json['price'] as int,
        owned: json['owned'] as bool,
      );
}

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<_ShopItem> _icons = [];
  List<_ShopItem> _frames = [];
  List<_ShopItem> _nameColors = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_fetchDecorations);
  }

  Future<void> _fetchDecorations() async {
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
              .map((e) => _ShopItem.fromJson(e as Map<String, dynamic>))
              .toList();
          _frames = (data['frames'] as List)
              .map((e) => _ShopItem.fromJson(e as Map<String, dynamic>))
              .toList();
          _nameColors = (data['name_colors'] as List)
              .map((e) => _ShopItem.fromJson(e as Map<String, dynamic>))
              .toList();
        });
      } else {
        toast("Failed to load shop items. ${body['message']}");
      }
    } catch (e) {
      toast("Something went wrong. $e");
    }
    setState(() => _isLoading = false);
  }

  Future<_BuyResult> _buyDecoration(String decorationId) async {
    try {
      final response = await fetch(
        "/shop/buy",
        HTTPMethod.post,
        body: {'decoration_id': decorationId},
        withAuth: true,
      );
      if (response.statusCode == 201) {
        setState(() {
          for (final list in [_icons, _frames, _nameColors]) {
            for (final item in list) {
              if (item.decorationId == decorationId) item.owned = true;
            }
          }
        });
        return _BuyResult.success;
      } else if (response.statusCode == 402) {
        return _BuyResult.notEnoughCoins;
      } else if (response.statusCode == 409) {
        return _BuyResult.alreadyBought;
      } else if (response.statusCode == 404) {
        return _BuyResult.notFound;
      }
    } catch (e) {
      toast("Something went wrong. $e");
    }
    return _BuyResult.error;
  }

  Future<void> _handleBuy(_ShopItem item) async {
    final coinProvider = context.read<CoinProvider>();
    final result = await _buyDecoration(item.decorationId);
    if (!mounted) return;
    switch (result) {
      case _BuyResult.success:
        coinProvider.decreaseCoin(item.price);
        toast("Purchase successful!");
      case _BuyResult.notEnoughCoins:
        toast("Not enough coins!");
      case _BuyResult.alreadyBought:
        toast("You already own this item!");
      case _BuyResult.notFound:
        toast("Item not found.");
      case _BuyResult.error:
        toast("Something went wrong.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoinProvider>(
      builder: (context, coinProvider, _) {
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
                        if (_icons.isNotEmpty) ...[
                          const _SectionHeader(title: "Avatars"),
                          const SizedBox(height: 12),
                          _ItemGrid(items: _icons, onBuy: _handleBuy),
                          const SizedBox(height: 24),
                        ],
                        if (_frames.isNotEmpty) ...[
                          const _SectionHeader(title: "Frames"),
                          const SizedBox(height: 12),
                          _ItemGrid(items: _frames, onBuy: _handleBuy),
                          const SizedBox(height: 24),
                        ],
                        if (_nameColors.isNotEmpty) ...[
                          const _SectionHeader(title: "Name Colors"),
                          const SizedBox(height: 12),
                          _ItemGrid(items: _nameColors, onBuy: _handleBuy),
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
                        children: [
                          const SVGIcon(
                            src: "assets/icons/CoinIcon.svg",
                            color: yellow100,
                            width: 14,
                            height: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${item.price}",
                            style: const TextStyle(
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

