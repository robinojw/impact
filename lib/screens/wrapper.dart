import 'package:flutter/material.dart';
import 'package:impact/models/impactUser.dart';
import 'package:impact/screens/authenticate/authenticate.dart';
import 'package:impact/screens/home/home.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/screens/welcome/energy_info.dart';
import 'package:impact/screens/welcome/get_started.dart';
import 'package:impact/screens/welcome/personal_info.dart';
import 'package:impact/screens/welcome/vechicle-info.dart';
import 'package:impact/services/auth.dart';
import 'package:impact/services/database.dart';
import 'package:impact/screens/shared/routing_constants.dart';
import 'package:provider/provider.dart';
import 'package:impact/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final AuthService _auth = AuthService();

    if (user == null) {
      return GetStarted();
    } else {
      return FutureBuilder(
          future: DatabaseService(uid: user.uid).getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;
              if ((userData.username == '') &&
                  (userData.energy == '') &&
                  (userData.electric == 0)) {
                return PersonalInfo();
              } else {
                return Home();
              }
            } else {
              print(snapshot.error);
              return GetStarted();
            }
          });
    }
  }
}
