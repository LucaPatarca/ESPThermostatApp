import 'package:go_router/go_router.dart';
import 'package:termostato/model/device.dart';
import 'package:termostato/model/schedule.dart';
import 'package:termostato/provider/settings_provider.dart';
import 'package:termostato/provider/thermostat_provider.dart';
import 'package:termostato/router/routing_path.dart';
import 'package:termostato/view/home.dart';
import 'package:termostato/view/shedule.dart';
import 'package:termostato/view/config.dart';
import 'package:termostato/widget/schedule_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabView extends StatefulWidget {
  const TabView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with TickerProviderStateMixin {
  bool _showFab = false;
  TabController? _controller;
  final ScheduleController _scheduleController = ScheduleController();

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    _controller?.addListener(() {
      setState(() {
        if (_controller?.indexIsChanging ?? true) {
          _showFab = false;
        } else {
          _showFab = _controller?.index == 1 ? true : false;
        }
      });
    });
    context.read<ThermostatProvider>().selectedDevice =
        context.read<SettingsProvider>().devices.first;
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final devices = context.watch<SettingsProvider>().devices;
    final thermProvider = context.watch<ThermostatProvider>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: DropdownMenu<Device>(
            initialSelection: devices.first,
            dropdownMenuEntries: devices
                .map((e) => DropdownMenuEntry(value: e, label: e.name))
                .toList(),
            inputDecorationTheme:
                const InputDecorationTheme(border: InputBorder.none),
            onSelected: (value) => setState(() {
              thermProvider.selectedDevice =
                  value ?? thermProvider.selectedDevice;
            }),
          ),
          actions: [
            IconButton(
              onPressed: () => context.push(RoutingPath.config),
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        bottomNavigationBar: TabBar(
          controller: _controller,
          labelColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          tabs: const [
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.schedule),
            )
          ],
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
            const HomePage(),
            SchedulePage(
              controller: _scheduleController,
            ),
          ],
        ),
        floatingActionButton: _showFab
            ? FloatingActionButton(
                onPressed: context.read<ThermostatProvider>().online
                    ? () async {
                        var result = await showDialog<Change?>(
                            context: context,
                            builder: (context) => ScheduleDialog(
                                  days: _scheduleController.selected,
                                ));
                        if (result != null) {
                          context.read<ThermostatProvider>().addChange(result);
                        }
                      }
                    : null,
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
