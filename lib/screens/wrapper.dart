import 'package:flutter/material.dart';
import 'package:impact/screens/authenticate/authenticate.dart';
import 'package:impact/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:impact/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
