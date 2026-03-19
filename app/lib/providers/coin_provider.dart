/*
 * File: coin_provider.dart
 * Description: Manages the user's coin balance and handles coin-related state changes for Edudoro.
 * Responsibilities:
 * - Loads coin balance from the server.
 * - Updates coin state and notifies listeners.
 * - Handles authentication failures and error messaging.
 * Notes: Manages coin score UI state and performs asynchronous API calls.
 * Author: Auttakorn Camsoi
 * Course: Mobile Application Development Framework
 */

import 'dart:convert';

import 'package:edudoro/utils/http.dart';
import 'package:edudoro/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Provider for managing the user's coin balance.
///
/// Fields:
/// - `_coin`: The user's current coin score.
///
/// Usage:
/// - Provided globally to display and update the user's balance across different screens.
class CoinProvider extends ChangeNotifier {
  int _coin = 0;

  /// The current coin balance.
  int get coin => _coin;

  /// Retrieves the coin balance from the server via HTTP.
  ///
  /// Async nature: Fetches data asynchronously from the network.
  /// Failure modes: Clears JWT token on 401 Unauthorized. Displays error toast and returns false if fetch fails or throws an exception.
  /// Side effects: Updates internal coin state and notifies listeners on success.
  /// Returns true if successful, false otherwise.
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
        final storage = FlutterSecureStorage();
        await storage.delete(key: "jwt_token");
        final msg = body['message'];
        toast("Something went wrong. $msg");
      }
      return false;
    } catch (e) {
      toast("Something went wrong. $e");
      return false;
    }
  }

  /// Increases the coin balance by [inputCoin].
  ///
  /// Side effects: Updates coin state and notifies listeners.
  void increaseCoin(int inputCoin) {
    _coin += inputCoin;
    notifyListeners();
  }

  /// Decreases the coin balance by [inputCoin], ensuring it does not go below zero.
  ///
  /// Side effects: Updates coin state and notifies listeners.
  void decreaseCoin(int inputCoin) {
    _coin = inputCoin > _coin ? 0 : _coin - inputCoin;
    notifyListeners();
  }
}
