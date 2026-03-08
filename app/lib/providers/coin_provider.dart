import 'dart:convert';

import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CoinProvider extends ChangeNotifier {
  int _coin = 0;

  int get coin => _coin;

  Future<bool> loadCoin() async {
    try {
      final response = await fetch("/score", HTTPMethod.get, withAuth: true);
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final score = body['data']?['score'];
        if (score != null) {
          _coin = score;
          notifyListeners();
          return true;
        }
      } else if (response.statusCode == 401) {
        final storage = FlutterSecureStorage();
        await storage.delete(key: "jwt_token");
      } else {
        final msg = body['message'];
        toast("Something went wrong. $msg");
      }
      return false;
    } catch (e) {
      toast("Something went wrong. $e");
      return false;
    }
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
