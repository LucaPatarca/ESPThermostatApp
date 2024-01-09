import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:termostato/model/device.dart';
import 'package:termostato/provider/settings_provider.dart';
import 'package:termostato/router/routing_path.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({Key? key}) : super(key: key);

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Configurazione iniziale")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  "Connettiti alla rete del dispositivo e inserisci le credenziali"),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(label: Text("Name")),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final device = Device(name: nameController.text);
          settings.devices = settings.devices..add(device);
          context.go(RoutingPath.home);
        },
        child: const Text("SAVE"),
      ),
    );
  }
}
