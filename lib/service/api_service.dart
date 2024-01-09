import 'package:termostato/model/activity.dart';
import 'package:termostato/model/schedule.dart';
import 'package:termostato/model/thermostat_modes.dart';
import 'package:termostato/model/thermostat_status.dart';

class ApiService {
  static final _service = ApiService._internal();

  factory ApiService() {
    return _service;
  }

  ApiService._internal();

  Future<bool> loadDeviceInfo() async {
    return false;
  }

  Future<ThermostatStatus> getCurrentStatus() async {
    return const ThermostatStatus();
  }

  Future<List<Activity>> getActivities() async {
    return [];
  }

  Future<bool> sendTargetTemperature(double temp) async {
    return false;
  }

  Future<bool> sendThermostatMode(ThermostatMode mode) async {
    return false;
  }

  Future<bool> sendScheduleChange(Schedule schedule, Change change) async {
    return false;
  }

  Future<bool> removeScheduleChange(Schedule schedule, Change change) async {
    return false;
  }
}
