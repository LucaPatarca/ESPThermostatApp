import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:termostato/model/schedule.dart';
import 'package:termostato/model/thermostat_modes.dart';
import 'package:termostato/model/thermostat_status.dart';
import 'package:termostato/service/auth_proxy.dart';
import 'package:termostato/service/http_interface.dart';
import 'package:termostato/service/http_service.dart';
import 'package:http/http.dart';

class ApiService {
  final HttpInterface _httpService = AuthProxy(HttpService());

  Future<bool> _sendAction(String action, Object value) async {
    String query = "clientId=${dotenv.env['CLIENT_ID'] ?? ""}&"
            "type=request&"
            "createdAt=${DateTime.now().millisecondsSinceEpoch}&"
            "action=$action&"
            "value=" +
        jsonEncode(value);
    String url =
        "https://api.sinric.pro/api/v1/devices/${dotenv.env['DEVICE_ID'] ?? ""}/action?$query";
    Request request = Request('GET', Uri.parse(url));
    StreamedResponse response = await _httpService.sendRequest(request);
    var json = jsonDecode(await response.stream.bytesToString());
    return json['success'] ?? false;
  }

  Future<bool> _sendSchedule(Schedule schedule) async {
    Request request =
        Request('PUT', Uri.parse("https://api.sinric.pro/api/v1/devices"));
    request.headers.addAll({
      'Content-Type': 'application/json',
    });
    request.body = jsonEncode({
      "id": dotenv.env['DEVICE_ID'] ?? "",
      "name": "Termostato",
      "productId": dotenv.env['PRODUCT_ID'] ?? "",
      "roomId": dotenv.env['ROOM_ID'] ?? "",
      "customData": jsonEncode(schedule.toJson()),
    });
    StreamedResponse response = await _httpService.sendRequest(request);
    Map<String, dynamic> json =
        jsonDecode(await response.stream.bytesToString());
    return json['success'] ?? false;
  }

  Future<ThermostatStatus> getCurrentStatus() async {
    Request request = Request(
        'GET',
        Uri.parse(
            "https://api.sinric.pro/api/v1/devices/${dotenv.env['DEVICE_ID'] ?? ""}"));
    StreamedResponse response = await _httpService.sendRequest(request);
    Map<String, dynamic> json =
        jsonDecode(await response.stream.bytesToString());
    try {
      return ThermostatStatus.fromJson(json["device"]);
    } catch (e) {
      return const ThermostatStatus();
    }
  }

  Future<bool> sendTargetTemperature(double temp) async {
    return _sendAction(
        "targetTemperature", {'temperature': (temp * 10).round() / 10});
  }

  Future<bool> sendThermostatMode(ThermostatMode mode) async {
    return _sendAction("setThermostatMode", {'thermostatMode': mode.value});
  }

  Future<bool> sendScheduleChange(Schedule schedule, Change change) async {
    var result = await _sendAction("setSetting",
        {"id": "ScheduleChange", "value": jsonEncode(change.toJson())});
    if (result) {
      schedule.changes.add(change);
      return _sendSchedule(schedule);
    }
    return false;
  }

  Future<bool> removeScheduleChange(Schedule schedule, Change change) async {
    var result = await _sendAction("setSetting",
        {"id": "ScheduleChangeRemove", "value": jsonEncode(change.toJson())});
    if (result) {
      schedule.changes.remove(change);
      return _sendSchedule(schedule);
    }
    return false;
  }
}
