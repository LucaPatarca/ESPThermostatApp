import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
    return false;
  }

  Future<bool> refreshToken() async {
    return false;
  }

  void logout() {
    _storage.deleteAll();
  }
}
