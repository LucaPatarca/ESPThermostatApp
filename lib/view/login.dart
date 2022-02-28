import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:termostato/service/auth_service.dart';
import 'package:termostato/view/tabs.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  Future<String?> _authUser(LoginData data) async {
    var _service = AuthService();
    var result = await _service.authenticate(data.name, data.password);
    if (!result) {
      return "Login error";
    }
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.value("Non implementato");
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'SinricPro',
      onLogin: _authUser,
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
