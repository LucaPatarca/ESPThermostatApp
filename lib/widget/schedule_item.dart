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
        (change.fromHour~/2).toString() + ":" + (change.fromHour%2>0?"30":"00") + " - "  
        + (change.toHour~/2).toString() + ":" + (change.toHour%2>0?"30":"00"),
      ),
      trailing: TextButton(
        onPressed: context.read<ThermostatProvider>().online?() {
          context.read<ThermostatProvider>().removeChange(change);
        }:null,
        child: const Icon(Icons.delete),
      ),
    );
  }
}
