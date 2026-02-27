import 'dart:convert';

import 'package:edudoro/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

enum HTTPMethod { post, get, put, delete }

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
  }
  return delete(uri, headers: requestHeaders);
}
