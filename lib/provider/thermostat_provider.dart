import 'dart:async';

import 'package:termostato/model/activity.dart';
import 'package:termostato/model/device.dart';
import 'package:termostato/model/schedule.dart';
import 'package:termostato/model/thermostat_modes.dart';
import 'package:termostato/model/thermostat_status.dart';
import 'package:termostato/service/api_service.dart';
import 'package:flutter/material.dart';

class ThermostatProvider with ChangeNotifier {
  final ApiService _service = ApiService();

  ThermostatStatus _status = const ThermostatStatus();
  List<Activity> _activities = [];
  Device _selectedDevice = Device();

  Future<void> loadStatus() async {
    var result = await _service.getCurrentStatus();
    var activities = await _service.getActivities();
    _status = result;
    _activities = activities;
    notifyListeners();
  }

  ThermostatMode get selectedMode => _status.mode;
  double get targetTemp => _status.targetTemperature;
  double get currentTemp => _status.currentTemperature;
  double get currentHumidity => _status.currentHumidity;
  bool get online => _status.online;
  Schedule get schedule => _status.schedule;
  List<Activity> get activities => _activities;
  Device get selectedDevice => _selectedDevice;

  set targetTemp(double value) {
    _service.sendTargetTemperature(value);
  }

  set selectedMode(ThermostatMode mode) {
    _service.sendThermostatMode(mode);
  }

  set selectedDevice(Device device) {
    _selectedDevice = device;
    notifyListeners();
  }

  addChange(Change change) async {
    await _service.sendScheduleChange(_status.schedule, change);
    notifyListeners();
  }

  removeChange(Change change) async {
    await _service.removeScheduleChange(_status.schedule, change);
    notifyListeners();
  }

  copyDay(int from, int to) {
    for (var change in _status.schedule.changes) {
      change.days.remove(to);
      if (change.days.contains(from)) {
        change.days.add(to);
      } else if (change.days.isEmpty) {
        _status.schedule.changes.remove(change);
      }
    }
  }
}
