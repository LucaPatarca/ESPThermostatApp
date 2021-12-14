import 'package:termostato/model/thermostat_modes.dart';
import 'package:termostato/provider/thermostat_provider.dart';
import 'package:termostato/widget/temp_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TempSelector(),
          DropdownButton(
            value: context.watch<ThermostatProvider>().selectedMode,
            items: ThermostatMode.values
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e.name),
                    value: e,
                  ),
                )
                .toList(),
            onChanged: context.watch<ThermostatProvider>().online
                ? (ThermostatMode? value) {
                    if (value != null) {
                      context.read<ThermostatProvider>().selectedMode = value;
                    }
                  }
                : null,
          )
        ],
      ),
    );
  }
}
