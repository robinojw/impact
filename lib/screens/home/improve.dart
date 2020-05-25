import 'package:flutter/material.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';

class Improve extends StatefulWidget {
  @override
  _ImproveState createState() => _ImproveState();
}

class _ImproveState extends State<Improve> {
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
              child: Column(children: <Widget>[
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Decrease your impact',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Icon(Icons.help, color: Colors.grey, size: 18),
                  ],
                ),
                SizedBox(height: 15),
                Container(
                  width: 400,
                  height: 180,
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/underground.png'),
                          fit: BoxFit.cover),
                      border: Border.all(width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Guide to London Transport',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text('Lower the impact of your commute',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.normal)),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Low impact alternatives',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Icon(Icons.help, color: Colors.grey, size: 18),
                  ],
                ),
                SizedBox(height: 15),

                //List of Items Currently Available
              ]),
            );
          } else {
            return Container(height: 0);
          }
        });
  }
}
