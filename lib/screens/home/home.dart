import 'package:flutter/material.dart';
import 'package:impact/models/impactUser.dart';
import 'package:impact/screens/home/setting_form.dart';
import 'package:impact/screens/shared/constants.dart';
import 'package:impact/services/auth.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';
import 'package:impact/screens/home/user_list.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<ImpactUser>>.value(
        value: DatabaseService().users,
        child: Container(
          decoration: backgroundGradient,
          padding: EdgeInsets.all(10),
          height: 2000,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Your impact levels are',
                        style: TextStyle(color: Colors.white, fontSize: 16.0)),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 24.0,
                    )
                  ],
                ),
                Container(child: UserList()),
                Text('Average',
                    style: TextStyle(color: Colors.yellow, fontSize: 16.0)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Today\'s total:',
                        style: TextStyle(
                            fontSize: 12, color: Colors.white, height: 0.9)),
                    Text('2446',
                        style: TextStyle(
                            fontSize: 60,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 0.95)),
                    Text('grams of greenhouse emissions',
                        style: TextStyle(
                            fontSize: 12, color: Colors.white, height: 0.5)),
                  ],
                ),
                FlatButton.icon(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                  color: Colors.white,
                  onPressed: () => _showSettingsPanel(),
                ),
                SizedBox(
                    height: 50,
                    width: 150,
                    child: RaisedButton(
                      child: Text('Log Out'),
                      onPressed: () {
                        _auth.signOut();
                      },
                    )),
              ],
            ),
          ),
        ));
  }
}
