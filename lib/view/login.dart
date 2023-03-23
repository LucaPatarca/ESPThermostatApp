import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:termostato/provider/settings_provider.dart';
import 'package:termostato/service/api_service.dart';
import 'package:termostato/service/auth_service.dart';
import 'package:termostato/view/tabs.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<String?> _authUser(LoginData data, BuildContext context) async {
    var service = AuthService();
    var result = await service.authenticate(data.name, data.password);
    if (!result) {
      return "Login error";
    }
    context.read<SettingsProvider>().email = data.name;
    result = await ApiService().loadDeviceInfo();
    if (!result) {
      return "No device found";
    }
    return null;
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.value("Non implementato");
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'SinricPro',
      onLogin: (data) async => await _authUser(data, context),
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const TabView(title: 'Termostato'),
        ));
      },
      onRecoverPassword: _recoverPassword,
      hideForgotPasswordButton: true,
    );
  }
}
