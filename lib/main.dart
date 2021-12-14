import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:termostato/app.dart';
import 'package:termostato/provider/thermostat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: "keys.env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThermostatProvider())
    ],
    child: const App(),
  ));
}
