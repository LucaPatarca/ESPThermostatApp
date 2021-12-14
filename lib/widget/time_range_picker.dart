import 'package:flutter/material.dart';

class TimeRangePicker extends StatefulWidget {
  final TimeRangeController? controller;
  const TimeRangePicker({Key? key, this.controller}) : super(key: key);

  @override
  _TimeRangePickerState createState() => _TimeRangePickerState();
}

class _TimeRangePickerState extends State<TimeRangePicker> {
  TimeRangeController _controller = TimeRangeController();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? _controller;
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
                    _controller.from = value;
                  }
                });
              },
              hint: const Text("Da"),
              value: _controller.from,
              items: Iterable<int>.generate(48)
                  .map((e) => DropdownMenuItem(
                        child: Text((e / 2).floor().toString() +
                            ":" +
                            ((e % 2 == 0) ? "00" : "30")),
                        value: e,
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
                    _controller.to = value;
                  }
                });
              },
              hint: const Text("A"),
              value: _controller.to,
              items: Iterable<int>.generate(49)
                  .where((e) => e > _controller.from)
                  .map((e) => DropdownMenuItem(
                        child: Text((e / 2).floor().toString() +
                            ":" +
                            ((e % 2 == 0) ? "00" : "30")),
                        value: e,
                      ))
                  .toList(),
            ),
          ],
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
