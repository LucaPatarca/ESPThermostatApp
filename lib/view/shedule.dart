import 'package:termostato/model/week_day.dart';
import 'package:termostato/provider/thermostat_provider.dart';
import 'package:termostato/widget/schedule_item.dart';
import 'package:termostato/widget/week_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SchedulePage extends StatefulWidget {
  final ScheduleController? controller;
  const SchedulePage({Key? key, this.controller}) : super(key: key);

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  ScheduleController _controller = ScheduleController();

  @override
  void initState() {
    _controller = widget.controller ?? _controller;
    _controller.onChange = setState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WeekButton(WeekDay.lun, _controller),
            WeekButton(WeekDay.mar, _controller),
            WeekButton(WeekDay.mer, _controller),
            WeekButton(WeekDay.gio, _controller),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            WeekButton(WeekDay.ven, _controller),
            WeekButton(WeekDay.sab, _controller),
            WeekButton(WeekDay.dom, _controller),
          ],
        ),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: context
                .watch<ThermostatProvider>()
                .schedule
                .changes
                .where((element) =>
                    _controller.selected.any((e) => element.days.contains(e)))
                .map((e) => ScheduleItem(change: e))
                .toList(),
          ),
        )
      ],
    );
  }
}

class ScheduleController {
  final Set<int> selected = {0};
  void Function(void Function())? onChange;

  ScheduleController({this.onChange});

  void add(int value) {
    if (onChange != null) {
      onChange!(() {
        selected.add(value);
      });
    } else {
      selected.add(value);
    }
  }

  void remove(int value) {
    if (onChange != null) {
      onChange!(() {
        selected.remove(value);
      });
    } else {
      selected.remove(value);
    }
  }

  void select(int value) {
    if (onChange != null) {
      onChange!(() {
        selected.clear();
        selected.add(value);
      });
    } else {
      selected.clear();
      selected.add(value);
    }
  }
}
