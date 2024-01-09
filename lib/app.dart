import 'package:flutter/material.dart';
import 'package:termostato/router/router.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routerConfig: AppRouter(),
      debugShowCheckedModeBanner: false,
    );
  }
}
