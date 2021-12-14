import 'dart:convert';

import 'package:termostato/model/schedule.dart';
import 'package:termostato/model/thermostat_modes.dart';

class ThermostatStatus {
  final double currentTemperature;
  final double currentHumidity;
  final ThermostatMode mode;
  final double targetTemperature;
  final bool online;
  final Schedule schedule;

  const ThermostatStatus(
      {this.currentTemperature = 20,
      this.currentHumidity = 60,
      this.mode = ThermostatMode.auto,
      this.targetTemperature = 15,
      this.online = false,
      this.schedule = const Schedule()});

  ThermostatStatus.fromJson(Map<String, dynamic> json)
      : currentTemperature = json['temperature'].toDouble() ?? 0,
        currentHumidity = json['humidity'].toDouble() ?? 0,
        mode = ThermostatMode.values.firstWhere(
            (element) =>
                element.value.toLowerCase() ==
                json['thermostatMode'].toLowerCase(),
            orElse: () => ThermostatMode.off),
        targetTemperature = json['targetTemperature'].toDouble() ?? 0,
        online = json['isOnline'] ?? false,
        schedule = Schedule.fromJson(jsonDecode(json['customData']));
}
