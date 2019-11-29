import "package:flutter/material.dart";
import "package:login_bloc/src/screens/app.dart";
import 'package:login_bloc/src/screens/login_screen.dart';
import 'package:login_bloc/src/screens/root_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impact',
      home: Scaffold(
        body: App(),
      ),
    );
  }
}
