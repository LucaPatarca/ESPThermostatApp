import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  late SharedPreferences _prefs;

  SettingsProvider() {
    SharedPreferences.getInstance().then((value) => _prefs = value);
  }

  String get name => _prefs.getString("NAME") ?? "User";
  set name(String value) {
    _prefs.setString("NAME", value);
    notifyListeners();
  }

  String get email => _prefs.getString("EMAIL") ?? "non autenticato";
  set email(String value) {
    _prefs.setString("EMAIL", value);
    notifyListeners();
  }
}
