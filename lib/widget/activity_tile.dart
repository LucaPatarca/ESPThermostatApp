import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:termostato/model/activity.dart';
import 'package:termostato/provider/settings_provider.dart';

class ActivityTile extends StatelessWidget {
  final Activity activity;
  final List<Icon> _icons = const [
    Icon(Icons.thermostat),
    Icon(Icons.settings_power),
    Icon(Icons.schedule),
    Icon(Icons.settings)
  ];
  const ActivityTile({Key? key, required this.activity}) : super(key: key);

  String timeAgo(DateTime d) {
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "anno" : "anni"} fa";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "mese" : "mesi"} fa";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "settimana" : "settimana"} fa";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "giorno" : "giorni"} fa";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "ora" : "ore"} fa";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minuto" : "minuti"} fa";
    }
    return "ora";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text((activity.clientId == context.watch<SettingsProvider>().name
              ? "Tu hai "
              : activity.displayClient + " ha ") +
          activity.type.displayMessage),
      subtitle: Text(timeAgo(activity.time)),
      leading: _icons[activity.type.index],
      isThreeLine: false,
    );
  }
}
