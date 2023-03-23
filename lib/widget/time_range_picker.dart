import 'package:flutter/material.dart';

class TimeRangePicker extends StatefulWidget {
  final TimeRangeController? timeRangeController;
  final TextEditingController? tempController;
  const TimeRangePicker(
      {Key? key, this.timeRangeController, this.tempController})
      : super(key: key);

  @override
  State createState() => _TimeRangePickerState();
}

class _TimeRangePickerState extends State<TimeRangePicker> {
  TimeRangeController _timeRangeController = TimeRangeController();
  TextEditingController _tempController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _timeRangeController = widget.timeRangeController ?? _timeRangeController;
    _tempController = widget.tempController ?? _tempController;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Da"),
            DropdownButton(
              onChanged: (int? value) {
                setState(() {
                  if (value != null) {
                    _timeRangeController.from = value;
                  }
                });
              },
              hint: const Text("Da"),
              value: _timeRangeController.from,
              items: Iterable<int>.generate(48)
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text("${(e / 2).floor()}:${(e % 2 == 0) ? "00" : "30"}"),
                      ))
                  .toList(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("A"),
            DropdownButton(
              onChanged: (int? value) {
                setState(() {
                  if (value != null) {
                    _timeRangeController.to = value;
                  }
                });
              },
              hint: const Text("A"),
              value: _timeRangeController.to,
              items: Iterable<int>.generate(49)
                  .where((e) => e > _timeRangeController.from)
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text("${(e / 2).floor()}:${(e % 2 == 0) ? "00" : "30"}"),
                      ))
                  .toList(),
            ),
          ],
        ),
        TextField(
          controller: _tempController,
          maxLength: 4,
          decoration: const InputDecoration(
              labelText: "Temperatura...", counterText: ""),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

class TimeRangeController {
  int _from = 24;
  int _to = 26;

  int get from => _from;
  int get to => _to;

  set from(int value) {
    if (value > 47 || value < 0) {
      throw Exception("value must be between 0 and 47");
    }
    _from = value;
    if (_from >= _to) {
      _to = value + 1;
    }
  }

  set to(int value) {
    if (value > 48 || value < 1) {
      throw Exception("value must be between 1 and 48");
    }
    _to = value;
    if (_to <= _from) {
      _from = value - 1;
    }
  }
}
