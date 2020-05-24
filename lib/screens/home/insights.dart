import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';

class Insights extends StatefulWidget {
  @override
  _InsightsState createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50),
                  viewSlider(),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }

  Widget viewSlider() {
    int currentTab = 0;
    final Map<int, Widget> tabs = const <int, Widget>{
      0: Text("D"),
      1: Text("W"),
      3: Text("M"),
      4: Text("Y"),
    };

    return CupertinoSlidingSegmentedControl(
        groupValue: currentTab,
        children: tabs,
        onValueChanged: (i) {
          setState(() {
            currentTab = i;
          });
        });
  }
}
