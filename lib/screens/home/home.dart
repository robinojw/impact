import 'package:flutter/material.dart';
import 'package:impact/models/impactUser.dart';
import 'package:impact/screens/shared/constants.dart';
import 'package:impact/services/auth.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';
import 'package:impact/screens/home/user_list.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ImpactUser>>.value(
      value: DatabaseService().users,
      child: Container(
        decoration: backgroundGradient,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(child: UserList()),
                SizedBox(
                    height: 50,
                    width: 150,
                    child: RaisedButton(
                      child: Text('Log Out'),
                      onPressed: () {
                        _auth.signOut();
                      },
                    )),
              ]),
        ),
      ),
    );
  }
}
