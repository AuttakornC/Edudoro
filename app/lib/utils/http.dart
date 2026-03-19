/*
 * File: http.dart
 * Description: Provides HTTP utility functions for network requests in Edudoro.
 * Responsibilities:
 * - Defines supported HTTP methods.
 * - Handles authenticated and unauthenticated requests.
 * - Serializes request bodies and manages headers.
 * Notes: Separates network logic entirely from the UI. Contains async operations for network calls and secure storage access.
 * Author: Auttakorn Camsoi
 * Course: Mobile Application Development Framework
 */

import 'dart:convert';

import 'package:edudoro/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

/// Supported HTTP methods for network requests.
enum HTTPMethod { post, get, put, delete, patch }

/// Fetches data by sending an HTTP request to the given [url] using the specified [method].
///
/// Async nature: Awaits secure storage read, then performs asynchronous HTTP calls.
/// 
/// If [withAuth] is true, includes a JWT token from secure storage in the Authorization header.
///
/// [body] is encoded as JSON for POST, PUT, and PATCH requests.
///
/// Returns the [Response] from the server.
///
/// Failure modes:
/// - Returns non-200 [Response] for server errors or authentication failures.
/// - Throws exception if network is unavailable or request times out.
Future<Response> fetch(
  String url,
  HTTPMethod method, {
  Map<String, dynamic>? body,
  Map<String, String>? headers,
  bool? withAuth,
}) async {
  final uri = Uri.parse("$SERVER_PATH$url");
  final requestHeaders = <String, String>{};
  if (headers != null) {
    requestHeaders.addAll(headers);
  }
  if (withAuth != null && withAuth) {
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: "jwt_token");
    if (token != null) {
      requestHeaders['Authorization'] = "Bearer $token";
    }
  }

  if (method == HTTPMethod.post) {
    requestHeaders.putIfAbsent('Content-Type', () => 'application/json');

    return post(
      uri,
      headers: requestHeaders,
      body: jsonEncode(body ?? <String, String>{}),
    );
  } else if (method == HTTPMethod.get) {
    return get(uri, headers: requestHeaders);
  } else if (method == HTTPMethod.put) {
    requestHeaders.putIfAbsent('Content-Type', () => 'application/json');
    return put(
      uri,
      headers: requestHeaders,
      body: jsonEncode(body ?? <String, String>{}),
    );
  } else if (method == HTTPMethod.patch) {
    requestHeaders.putIfAbsent('Content-Type', () => 'application/json');
    return patch(
      uri,
      headers: requestHeaders,
      body: jsonEncode(body ?? <String, String>{}),
    );
  }
  return delete(uri, headers: requestHeaders);
}
