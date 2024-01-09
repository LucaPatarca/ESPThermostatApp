import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:termostato/model/device.dart';

class SettingsProvider with ChangeNotifier {
  SharedPreferences prefs;

  SettingsProvider(this.prefs);

  String get name => prefs.getString("NAME") ?? "User";
  set name(String value) {
    prefs.setString("NAME", value);
    notifyListeners();
  }

  String get email => prefs.getString("EMAIL") ?? "non autenticato";
  set email(String value) {
    prefs.setString("EMAIL", value);
    notifyListeners();
  }

  List<Device> get devices {
    final jsonString = prefs.getString("DEVICES") ?? "[]";
    final Iterable json = jsonDecode(jsonString) as Iterable;
    return json
        .whereType<Map<String, dynamic>>()
        .map((e) => Device.fromJson(e))
        .toList();
  }

  set devices(List<Device> devices) {
    prefs.setString(
        "DEVICES", jsonEncode(devices.map((e) => e.toJson()).toList()));
  }
}
