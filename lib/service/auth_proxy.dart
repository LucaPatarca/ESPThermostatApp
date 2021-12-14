import 'dart:convert';

import 'package:termostato/service/http_interface.dart';
import 'package:termostato/service/auth_service.dart';
import 'package:http/http.dart';

class AuthProxy extends HttpInterface {
  final HttpInterface _innerService;
  final AuthService _authService = AuthService();

  String token = "";

  AuthProxy(HttpInterface inner) : _innerService = inner;

  @override
  Future<StreamedResponse> sendRequest(Request request) async {
    request.headers.addAll({'Authorization': 'Bearer ' + token});
    var response = await _innerService.sendRequest(request);
    if (response.statusCode == 401) {
      token = jsonDecode(await _authService.authenticate())['accessToken'];
      var newRequest = Request(request.method, request.url);
      newRequest.headers['Authorization'] = 'Bearer ' + token;
      return _innerService.sendRequest(newRequest);
    } else {
      return response;
    }
  }
}
