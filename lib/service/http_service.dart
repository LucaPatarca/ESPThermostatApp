import 'package:termostato/service/http_interface.dart';
import 'package:http/http.dart';

class HttpService extends HttpInterface {
  @override
  Future<StreamedResponse> sendRequest(Request request) async {
    return await request.send();
  }
}
