import 'package:termostato/model/schedule.dart';
import 'package:termostato/provider/thermostat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduleItem extends StatelessWidget {
  final Change change;
  const ScheduleItem({Key? key, required this.change}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(change.temp.toString() + " C"),
      subtitle: Text(
        change.fromHour.toString() + " -> " + change.toHour.toString(),
      ),
      trailing: TextButton(
        onPressed: () {
          context.read<ThermostatProvider>().removeChange(change);
        },
        child: const Icon(Icons.delete),
      ),
    );
  }
}
