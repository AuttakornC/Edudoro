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
