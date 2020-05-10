import 'package:flutter/material.dart';
import 'package:impact/screens/home/home.dart';
import 'package:impact/screens/welcome/get_started.dart';
import 'package:impact/screens/welcome/personal_info.dart';
import 'package:impact/services/database.dart';
import 'package:impact/screens/shared/routing_constants.dart';
import 'package:provider/provider.dart';
import 'package:impact/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    final userData = UserData().name;

    if (user == null) {
      return GetStarted();
    } else {
      if (userData == null) {
        return PersonalInfo();
      } else {
        return Home();
      }
    }
  }
}
