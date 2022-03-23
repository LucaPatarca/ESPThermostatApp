import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:termostato/model/activity.dart';
import 'package:termostato/provider/thermostat_provider.dart';
import 'package:termostato/widget/activity_tile.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: context
          .watch<ThermostatProvider>()
          .activities
          .take(_showAll ? 30 : 3)
          .map<Widget>((e) => ActivityTile(activity: e))
          .toList()
        ..add(
          TextButton(
            onPressed: _showAll
                ? null
                : () {
                    setState(() {
                      _showAll = true;
                    });
                  },
            child: const Text("Altro..."),
          ),
        ),
    );
  }
}
