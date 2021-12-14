enum ThermostatMode { on, off, auto }

extension ThermostatModesExtention on ThermostatMode {
  String get value {
    const values = ["HEAT", "OFF", "AUTO"];
    return values[index];
  }

  String get name {
    const values = ["Acceso", "Spento", "Programma"];
    return values[index];
  }

  ThermostatMode fromString(String string) {
    return ThermostatMode.auto;
  }
}
