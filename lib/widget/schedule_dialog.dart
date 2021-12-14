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
  final TimeRangeController _controller = TimeRangeController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Aggiungi Programma"),
      content: TimeRangePicker(
        controller: _controller,
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
                Change(widget.days.toList(), _controller.from, _controller.to,
                    20));
          },
          child: const Text("Aggiungi"),
        ),
      ],
    );
  }
}
