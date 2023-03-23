import 'package:termostato/model/week_day.dart';
import 'package:termostato/provider/thermostat_provider.dart';
import 'package:termostato/view/shedule.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekButton extends StatelessWidget {
  final WeekDay day;
  final ScheduleController controller;
  const WeekButton(this.day, this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        controller.select(day.index);
      },
      onLongPress: context.read<ThermostatProvider>().online
          ? () async {
              if (controller.selected.contains(day.index) &&
                  controller.selected.length > 1) {
                controller.remove(day.index);
              } else if (!controller.selected.contains(day.index)) {
                bool? result = await showDialog<bool?>(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Copiare ${WeekDay.values[controller.selected.first].name} su ${day.name}?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text("Si"),
                            ),
                          ],
                        ));
                //TODO estrarre in un widget a se
                //TODO fare in modo che non ti chiede niente se uno dei due giorni e' vuoto
                if (result == true) {
                  context
                      .read<ThermostatProvider>()
                      .copyDay(controller.selected.first, day.index);
                  controller.add(day.index);
                }
              }
            }
          : null,
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
        backgroundColor: controller.selected.contains(day.index)
            ? MaterialStateProperty.all(Theme.of(context).primaryColor)
            : null,
        foregroundColor: controller.selected.contains(day.index)
            ? MaterialStateProperty.all(Colors.white)
            : null,
      ),
      child: Text(day.name),
    );
  }
}
