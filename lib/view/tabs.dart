import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:termostato/model/schedule.dart';
import 'package:termostato/provider/thermostat_provider.dart';
import 'package:termostato/view/home.dart';
import 'package:termostato/view/login.dart';
import 'package:termostato/view/shedule.dart';
import 'package:termostato/view/user.dart';
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
    const FlutterSecureStorage().containsKey(key: "TOKEN").then((value) => {
          if (!value)
            {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false)
            }
        });
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const UserPage()));
              },
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
