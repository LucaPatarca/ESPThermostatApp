import 'package:termostato/model/thermostat_modes.dart';
import 'package:http/http.dart';

abstract class HttpInterface {
  Future<StreamedResponse> sendRequest(Request request);
}
