enum ActivityType {
  setTarget,
  setMode,
  setSchedule,
  unknown,
}

extension Print on ActivityType {
  String get displayMessage {
    return [
      "cambiato la temperatura",
      "cambiato la modalità",
      "cambiato il programma",
      "eseguito un azione"
    ][index];
  }
}

class Activity {
  final String ipAddress;
  final String location;
  final String clientId;
  final String message;
  final String device;
  final DateTime time;
  final String id;

  ActivityType get type {
    var s = message.substring(message.indexOf("[") + 1, message.indexOf("]"));
    switch (s) {
      case "setTargetTemperature":
      case "targetTemperature":
        return ActivityType.setTarget;
      case "setThermostatMode":
      case "thermostatMode":
      case "powerState":
      case "setPowerState":
        return ActivityType.setMode;
      case "setSetting":
        return ActivityType.setSchedule;
      default:
        return ActivityType.unknown;
    }
  }

  String get displayClient {
    if (clientId == "alexa-skill") {
      return "Alexa";
    }
    return clientId;
  }

  Activity(
      {this.ipAddress = "0.0.0.0",
      this.clientId = "-",
      this.device = "-",
      this.id = "-",
      this.location = "-",
      this.message = "-"})
      : time = DateTime.now();

  Activity.fromJson(Map<String, dynamic> json)
      : ipAddress = json['ipAddress'],
        location = json['location'],
        clientId = json['clientId'],
        message = json['message'],
        device = json['device'],
        time = DateTime.parse(json['createdAt']),
        id = json['id'];
}
