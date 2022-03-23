import 'package:termostato/model/schedule.dart';
import 'package:termostato/widget/time_range_picker.dart';
import 'package:flutter/material.dart';

class ScheduleDialog extends StatefulWidget {
  final Set<int> days;
  const ScheduleDialog({Key? key, required this.days}) : super(key: key);

  @override
  State<ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<ScheduleDialog> {
  final TimeRangeController _timeRangeController = TimeRangeController();
  final TextEditingController _tempController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Aggiungi Programma"),
      content: TimeRangePicker(
        timeRangeController: _timeRangeController,
        tempController: _tempController,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: const Text("Annulla"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
                context,
                Change(
                    widget.days.toList(),
                    _timeRangeController.from,
                    _timeRangeController.to,
                    double.parse(_tempController.text)));
          },
          child: const Text("Aggiungi"),
        ),
      ],
    );
  }
}
