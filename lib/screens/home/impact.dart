import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_sequence_animator/image_sequence_animator.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/home/add_emission.dart';
import 'package:impact/screens/home/charts/day_chart.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/services/auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:impact/services/database.dart';
import 'package:nima/nima_actor.dart';
import 'package:provider/provider.dart';

class Impact extends StatefulWidget {
  @override
  _ImpactState createState() => _ImpactState();
}

class _ImpactState extends State<Impact> {
  final AuthService _auth = AuthService();
  Widget chart = DayChart.withSampleData();
  bool show = false;
  int listIndex = 0;
  int totalEmissions = 0;

  @override
  Widget build(BuildContext context) {
    void _addEmission() {
      showModalBottomSheet(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          context: context,
          builder: (context) {
            return Container(
              height: 350,
              color: Colors.transparent,
              child: Container(
                height: 350,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: AddEmission(),
              ),
            );
          });
    }

    return Container(
      height: MediaQuery.of(context).size.height - 84,
      padding: EdgeInsets.all(10),
      child: Stack(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Your impact levels are',
                      style: TextStyle(color: Colors.white, fontSize: 16.0)),
                  ButtonTheme(
                      minWidth: 0,
                      padding: EdgeInsets.all(0),
                      child: FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () => _addEmission(),
                        child: Icon(Icons.add, color: Colors.white, size: 24.0),
                      ))
                ]),
            Text('Average',
                style: TextStyle(
                    height: 0.5, color: Colors.yellow, fontSize: 16.0)),
            Container(height: 300, width: 400, child: animation()),
            total(),
          ],
        ),
        SizedBox(height: 20),
        Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(height: 175, child: chart)),
      ]),
    );
  }

  Widget animation() {
    return Container(height: 0);
  }

  Widget total() {
    final user = Provider.of<User>(context);
    return Container(
      height: 90,
      child: FutureBuilder<UserData>(
          future: DatabaseService(uid: user.uid).getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;
              for (var item in userData.emissions) {
                if (listIndex < userData.emissions.length) {
                  totalEmissions += item.ghGas;
                  listIndex++;
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Today\'s total:',
                      style: TextStyle(
                          fontSize: 12, color: Colors.white, height: 0.9)),
                  Text(totalEmissions.toString(),
                      style: TextStyle(
                          fontSize: 60,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 0.95)),
                  Text('grams of greenhouse emissions',
                      style: TextStyle(
                          fontSize: 12, color: Colors.white, height: 0.5)),
                ],
              );
            } else {
              return Container(height: 0);
            }
          }),
    );
  }
}
