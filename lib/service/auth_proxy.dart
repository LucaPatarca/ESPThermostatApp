import 'dart:convert';

import 'package:termostato/service/http_interface.dart';
import 'package:termostato/service/auth_service.dart';
import 'package:http/http.dart';

class AuthProxy extends HttpInterface {
  final HttpInterface _innerService;
  final AuthService _authService = AuthService();

  AuthProxy(HttpInterface inner) : _innerService = inner;

  @override
  Future<StreamedResponse> sendRequest(Request request) async {
    request.headers
        .addAll({'Authorization': 'Bearer ' + await _authService.loadToken()});
    var response = await _innerService.sendRequest(request);
    if (response.statusCode == 401) {
      await _authService.refreshToken();
      var newRequest = Request(request.method, request.url);
      newRequest.headers['Authorization'] =
          'Bearer ' + await _authService.loadToken();
      return _innerService.sendRequest(newRequest);
    } else {
      return response;
    }
  }
}
