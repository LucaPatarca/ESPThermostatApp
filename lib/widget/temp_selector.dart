import 'package:termostato/provider/thermostat_provider.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:provider/provider.dart';

class TempSelector extends StatefulWidget {
  const TempSelector({Key? key}) : super(key: key);

  @override
  State<TempSelector> createState() => _TempSelectorState();
}

class _TempSelectorState extends State<TempSelector> {
  @override
  Widget build(BuildContext context) {
    var _innerTextStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 22,
    );
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
          size: 200,
          customColors: CustomSliderColors(
            progressBarColors: [Colors.red, Colors.blue],
            trackColor: context.watch<ThermostatProvider>().online
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
          ),
          customWidths: CustomSliderWidths(
            progressBarWidth: 12,
            handlerSize: 4,
          ),
          infoProperties: InfoProperties(
              topLabelText: context.watch<ThermostatProvider>().online
                  ? context
                          .watch<ThermostatProvider>()
                          .currentTemp
                          .toStringAsFixed(1) +
                      " C"
                  : "offline",
              topLabelStyle: _innerTextStyle,
              bottomLabelText: context.watch<ThermostatProvider>().online
                  ? context
                          .watch<ThermostatProvider>()
                          .currentHumidity
                          .toStringAsFixed(1) +
                      " %"
                  : null,
              bottomLabelStyle: _innerTextStyle,
              modifier: (double value) => value.toStringAsFixed(1) + " C")),
      min: 15,
      max: 25,
      initialValue: context.watch<ThermostatProvider>().targetTemp,
      onChangeEnd: context.watch<ThermostatProvider>().online
          ? (double value) =>
              context.read<ThermostatProvider>().targetTemp = value
          : null,
    );
  }
}
