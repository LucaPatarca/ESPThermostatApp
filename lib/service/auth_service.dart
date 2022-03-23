import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class AuthService {
  static final AuthService _service = AuthService._internal();
  final _storage = const FlutterSecureStorage();
  static const tokenKey = 'TOKEN';
  static const refreshTokenKey = 'REFRESH_TOKEN';
  static const userIdKey = 'REFRESH_TOKEN';
  Codec<String, String> stringToBase64 = utf8.fuse(base64);

  factory AuthService() {
    return _service;
  }

  AuthService._internal();

  Future<String?> loadToken() async {
    return await _storage.read(key: tokenKey) ?? "";
  }

  Future<String?> loadRefreshToken() async {
    return await _storage.read(key: refreshTokenKey) ?? "";
  }

  Future<String?> loadUserId() async {
    return await _storage.read(key: userIdKey) ?? "";
  }

  Future<void> _saveToken(
      String token, String refreshToken, String userId) async {
    await _storage.write(key: tokenKey, value: token);
    await _storage.write(key: refreshTokenKey, value: refreshToken);
    await _storage.write(key: userIdKey, value: userId);
  }

  Future<bool> authenticate(String user, String password) async {
    print("authenticate");
    var auth = stringToBase64.encode("$user:$password");
    var headers = {
      'Authorization': "Basic $auth",
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var request =
        Request('POST', Uri.parse('https://api.sinric.pro/api/v1/auth'));
    request.bodyFields = {'client_id': "android-emulator"};
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    Map<String, dynamic> json =
        jsonDecode(await response.stream.bytesToString());
    if (json['success'] == true) {
      await _saveToken(
          json['accessToken'], json['refreshToken'], json['account']['id']);
      return true;
    }
    return false;
  }

  Future<bool> refreshToken() async {
    print("refresh token");
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var request = Request(
        'GET', Uri.parse('https://api.sinric.pro/api/v1/auth/refresh_token'));
    request.bodyFields = {
      'refreshToken': await loadRefreshToken() ?? "",
      'accountId': await loadUserId() ?? "",
    };
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    Map<String, dynamic> json =
        jsonDecode(await response.stream.bytesToString());
    if (json['success'] == true) {
      await _saveToken(
          json['accessToken'], json['refreshToken'], json['account']['id']);
      return true;
    } else {
      return false;
    }
  }

  void logout() {
    _storage.deleteAll();
  }
}
