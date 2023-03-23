import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:termostato/model/activity.dart';
import 'package:termostato/model/schedule.dart';
import 'package:termostato/model/thermostat_modes.dart';
import 'package:termostato/model/thermostat_status.dart';
import 'package:termostato/service/auth_proxy.dart';
import 'package:termostato/service/http_interface.dart';
import 'package:termostato/service/http_service.dart';
import 'package:http/http.dart';

class ApiService {
  static final _service = ApiService._internal();
  final HttpInterface _httpService = AuthProxy(HttpService());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  factory ApiService() {
    return _service;
  }

  ApiService._internal();

  Future<bool> _sendAction(String action, Object value) async {
    var prefs = await _prefs;
    String query = "clientId=${prefs.getString("NAME") ?? "Sconosciuto"}&"
            "type=request&"
            "createdAt=${DateTime.now().millisecondsSinceEpoch}&"
            "action=$action&"
            "value=${jsonEncode(value)}";
    String url =
        "https://api.sinric.pro/api/v1/devices/${prefs.getString("DEVICE_ID") ?? ""}/action?$query";
    Request request = Request('GET', Uri.parse(url));
    StreamedResponse response = await _httpService.sendRequest(request);
    var json = jsonDecode(await response.stream.bytesToString());
    return json['success'] ?? false;
  }

  Future<bool> _sendSchedule(Schedule schedule) async {
    var prefs = await _prefs;
    Request request =
        Request('PUT', Uri.parse("https://api.sinric.pro/api/v1/devices"));
    request.headers.addAll({
      'Content-Type': 'application/json',
    });
    request.body = jsonEncode({
      "id": prefs.getString("DEVICE_ID") ?? "",
      "name": "Termostato",
      "productId": prefs.getString("PRODUCT_ID") ?? "",
      "roomId": prefs.getString("ROOM_ID") ?? "",
      "customData": jsonEncode(schedule.toJson()),
    });
    StreamedResponse response = await _httpService.sendRequest(request);
    Map<String, dynamic> json =
        jsonDecode(await response.stream.bytesToString());
    return json['success'] ?? false;
  }

  Future<bool> loadDeviceInfo() async {
    var prefs = await _prefs;
    Request request =
        Request('GET', Uri.parse("https://api.sinric.pro/api/v1/devices/"));
    StreamedResponse response = await _httpService.sendRequest(request);
    Map<String, dynamic> json =
        jsonDecode(await response.stream.bytesToString());

    if (json['success'] != true) {
      return false;
    }

    Map<String, dynamic>? device = (json['devices'] as Iterable).firstWhere(
        (device) => device['product']['model'] == "SinricPro thermostat",
        orElse: () => null);

    if (device == null) {
      return false;
    }

    prefs.setString("DEVICE_ID", device['id']);
    prefs.setString("ROOM_ID", device['room']['id']);
    prefs.setString("PRODUCT_ID", device['product']['id']);
    return true;
  }

  Future<ThermostatStatus> getCurrentStatus() async {
    var prefs = await _prefs;
    Request request = Request(
        'GET',
        Uri.parse(
            "https://api.sinric.pro/api/v1/devices/${prefs.getString("DEVICE_ID") ?? ""}"));
    StreamedResponse response = await _httpService.sendRequest(request);
    Map<String, dynamic> json =
        jsonDecode(await response.stream.bytesToString());
    try {
      return ThermostatStatus.fromJson(json["device"]);
    } catch (e) {
      return const ThermostatStatus();
    }
  }

  Future<List<Activity>> getActivities() async {
    var prefs = await _prefs;
    Request request = Request(
        'GET',
        Uri.parse(
            "https://api.sinric.pro/api/v1/activitylog/device/${prefs.getString("DEVICE_ID") ?? ""}"));
    StreamedResponse response = await _httpService.sendRequest(request);
    Map<String, dynamic> json =
        jsonDecode(await response.stream.bytesToString());
    return (json['activitylogs'] as Iterable)
        .take(30)
        .map((e) => Activity.fromJson(e))
        .toList();
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
