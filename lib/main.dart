import 'package:termostato/app.dart';
import 'package:termostato/provider/settings_provider.dart';
import 'package:termostato/provider/thermostat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThermostatProvider()),
      ChangeNotifierProvider(
        create: (context) => SettingsProvider(),
        lazy: false,
      )
    ],
    child: const App(),
  ));
}
