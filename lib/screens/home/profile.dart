import 'package:flutter/material.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Widget textRow(String type, String value) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(children: <Widget>[
        Container(height: 1.5, width: 340, color: const Color(0xFF2E395F)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(type, style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: 5),
            Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        SizedBox(height: 10)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Column(
              children: <Widget>[
                Column(children: <Widget>[
                  SizedBox(height: 30),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.settings),
                            iconSize: 24,
                            color: Colors.white,
                            onPressed: () {})
                      ]),
                  new Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new AssetImage(
                                  'assets/default-profile.png')))),
                  SizedBox(height: 10),
                  Text(userData.name,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ]),
                SizedBox(height: 30),
                textRow("Name ", userData.name),
                textRow("Username ", userData.username),
                textRow("Vehicle ", userData.vehicle),
                textRow("Vehicle Fuel ", userData.fuel),
                textRow(
                    "Vehicle Mpg ", userData.vehicleMpg.toString() + " Mpg"),
                textRow("Heating Energy Type ", userData.energy),
                textRow("Heating Usage ", userData.heating.toString() + " KWh"),
                textRow("Electricity Source ", userData.electricity),
                textRow("Electricity Usage ",
                    userData.electric.toString() + " KWh"),
              ],
            );
          } else {
            return Container(height: 0);
          }
        });
  }
}
