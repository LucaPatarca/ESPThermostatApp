import 'package:termostato/view/tabs.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const TabView(title: 'Termostato'),
      debugShowCheckedModeBanner: false,
    );
  }
}
