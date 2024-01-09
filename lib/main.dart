import 'package:shared_preferences/shared_preferences.dart';
import 'package:termostato/app.dart';
import 'package:termostato/provider/settings_provider.dart';
import 'package:termostato/provider/thermostat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThermostatProvider()),
      ChangeNotifierProvider(create: (context) => SettingsProvider(prefs))
    ],
    child: const App(),
  ));
}
