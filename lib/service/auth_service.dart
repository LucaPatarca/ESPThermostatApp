import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  static const tokenKey = 'TOKEN';
  static const refreshTokenKey = 'REFRESH_TOKEN';
  static const userIdKey = 'REFRESH_TOKEN';

  Future<String> loadToken() async {
    var token = await _storage.read(key: tokenKey);
    if (token == null) {
      await authenticate();
    }
    return await _storage.read(key: tokenKey) ?? "";
  }

  Future<String> loadRefreshToken() async {
    var refreshToken = await _storage.read(key: refreshTokenKey);
    if (refreshToken == null) {
      await authenticate();
    }
    return await _storage.read(key: refreshTokenKey) ?? "";
  }

  Future<String> loadUserId() async {
    var id = await _storage.read(key: userIdKey);
    if (id == null) {
      await authenticate();
    }
    return await _storage.read(key: userIdKey) ?? "";
  }

  Future<void> _saveToken(
      String token, String refreshToken, String userId) async {
    await _storage.write(key: tokenKey, value: token);
    await _storage.write(key: refreshTokenKey, value: refreshToken);
    await _storage.write(key: userIdKey, value: userId);
  }

  Future<void> authenticate() async {
    print("authenticate");
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'x-sinric-api-key': dotenv.env["SINRICPRO_API_KEY"] ?? ""
    };
    var request =
        Request('POST', Uri.parse('https://api.sinric.pro/api/v1/auth'));
    request.bodyFields = {'client_id': dotenv.env["CLIENT_ID"] ?? ""};
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    Map<String, dynamic> json =
        jsonDecode(await response.stream.bytesToString());
    if (json['success'] == true) {
      await _saveToken(
          json['accessToken'], json['refreshToken'], json['account']['id']);
    }
  }

  Future<void> refreshToken() async {
    print("refresh token");
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var request = Request(
        'GET', Uri.parse('https://api.sinric.pro/api/v1/auth/refresh_token'));
    request.bodyFields = {
      'refreshToken': await loadRefreshToken(),
      'accountId': await loadUserId(),
    };
    request.headers.addAll(headers);

    StreamedResponse response = await request.send();

    Map<String, dynamic> json =
        jsonDecode(await response.stream.bytesToString());
    if (json['success'] == true) {
      await _saveToken(
          json['accessToken'], json['refreshToken'], json['account']['id']);
    } else {
      await authenticate();
    }
  }
}
