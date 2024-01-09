import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:termostato/provider/settings_provider.dart';
import 'package:termostato/provider/thermostat_provider.dart';
import 'package:termostato/router/routing_path.dart';
import 'package:termostato/service/auth_service.dart';
import 'package:termostato/view/login.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _userTextController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    _userTextController.text =
        context.read<ThermostatProvider>().selectedDevice.name;
    _focusNode.addListener(() {
      if (!_focusNode.hasPrimaryFocus) {
        _saveText();
      }
    });
    super.initState();
  }

  void _saveText() {
    context.read<SettingsProvider>().name = _userTextController.text;
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final selectedDevice = context.watch<ThermostatProvider>().selectedDevice;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Impostazioni"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: EditableText(
                          controller: _userTextController,
                          focusNode: _focusNode,
                          cursorColor: Colors.black,
                          backgroundCursorColor: Colors.black,
                          style: const TextStyle(
                              fontSize: 32, color: Colors.black),
                          textAlign: TextAlign.center,
                          onEditingComplete: () => _focusNode.unfocus(),
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Connessioni",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: ListView(
                    children: settings.devices
                        .map((e) => ListTile(
                              title: Text(e.name),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete)),
                            ))
                        .toList(),
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    settings.devices = settings.devices..remove(selectedDevice);
                    context.go(RoutingPath.home);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text(
                    "Elimina Dispositivo",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    AuthService().logout();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false);
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
