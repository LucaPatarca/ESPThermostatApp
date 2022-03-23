import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:termostato/provider/settings_provider.dart';
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
    _userTextController.text = context.read<SettingsProvider>().name;
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
                Text(
                  context.watch<SettingsProvider>().email,
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).disabledColor),
                  textAlign: TextAlign.center,
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
