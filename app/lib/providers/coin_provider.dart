import 'dart:convert';

import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';

class CoinProvider extends ChangeNotifier {
  int _coin = 0;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  int get coin => _coin;

  CoinProvider() {
    _loadCoin();
  }

  Future<void> _loadCoin() async {
    _setLoading(true);
    try {
      final response = await fetch("/score", HTTPMethod.get);
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final score = body['data']?['score'];
        if (score != null) {
          _coin = score;
        }
      } else {
        final msg = body['message'];
        toast("Something went wrong. $msg");
      }
    } catch (e) {
      toast("Something went wrong. $e");
    }
    _setLoading(false);
  }

  void _setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  void increaseCoin(int inputCoin) {
    _coin += inputCoin;
    notifyListeners();
  }

  void decreaseCoin(int inputCoin) {
    _coin = inputCoin > _coin ? 0 : _coin - inputCoin;
    notifyListeners();
  }
}
