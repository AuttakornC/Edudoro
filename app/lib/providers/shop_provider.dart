import 'dart:convert';
import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';

enum BuyResult { success, notEnoughCoins, alreadyBought, notFound, error }

class ShopDecorationItem {
  final String decorationId;
  final String detail;
  bool owned;

  ShopDecorationItem({
    required this.decorationId,
    required this.detail,
    required this.owned,
  });

  factory ShopDecorationItem.fromJson(Map<String, dynamic> json) =>
      ShopDecorationItem(
        decorationId: json['decoration_id'] as String,
        detail: json['detail'] as String,
        owned: json['owned'] as bool,
      );
}

class ShopProvider extends ChangeNotifier {
  List<ShopDecorationItem> icons = [];
  List<ShopDecorationItem> frames = [];
  List<ShopDecorationItem> nameColors = [];
  bool isLoading = false;

  Future<void> fetchDecorations() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await fetch(
        "/shop/decorations",
        HTTPMethod.get,
        withAuth: true,
      );
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = body['data'];
        icons = (data['icons'] as List)
            .map((e) => ShopDecorationItem.fromJson(e as Map<String, dynamic>))
            .toList();
        frames = (data['frames'] as List)
            .map((e) => ShopDecorationItem.fromJson(e as Map<String, dynamic>))
            .toList();
        nameColors = (data['name_colors'] as List)
            .map((e) => ShopDecorationItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        final msg = body['message'];
        toast("Failed to load shop items. $msg");
      }
    } catch (e) {
      toast("Something went wrong. $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<BuyResult> buyDecoration(String decorationId) async {
    try {
      final response = await fetch(
        "/shop/buy",
        HTTPMethod.post,
        body: {'decoration_id': decorationId},
        withAuth: true,
      );
      if (response.statusCode == 201) {
        for (final list in [icons, frames, nameColors]) {
          for (final item in list) {
            if (item.decorationId == decorationId) {
              item.owned = true;
            }
          }
        }
        notifyListeners();
        return BuyResult.success;
      } else if (response.statusCode == 402) {
        return BuyResult.notEnoughCoins;
      } else if (response.statusCode == 409) {
        return BuyResult.alreadyBought;
      } else if (response.statusCode == 404) {
        return BuyResult.notFound;
      }
    } catch (e) {
      toast("Something went wrong. $e");
    }
    return BuyResult.error;
  }
}
