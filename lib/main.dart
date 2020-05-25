import 'package:flutter/material.dart';
import 'package:impact/screens/wrapper.dart';
import 'package:impact/services/auth.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'package:impact/services/routing.dart' as router;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: router.generateRoute,
        home: Wrapper(),
      ),
    );
  }
}
