import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impact/models/impactUser.dart';
import 'package:impact/screens/home/setting_form.dart';
import 'package:impact/screens/shared/constants.dart';
import 'package:impact/services/auth.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';
import 'package:impact/screens/home/user_list.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _index = 2;

    return StreamProvider<List<ImpactUser>>.value(
        value: DatabaseService().users,
        child: Container(
          decoration: backgroundGradient,
          height: 800,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CupertinoTabBar(
                      currentIndex: _index,
                      backgroundColor: Colors.transparent,
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.group), title: Text('Group')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.nature), title: Text('Improve')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.public), title: Text('Impact')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.timeline),
                            title: Text('Insights')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.person), title: Text('Profile')),
                      ]),
                ]),
          ),
        ));
  }
}
