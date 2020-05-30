import 'dart:async';

import 'package:flutter/material.dart';

import 'package:impact/models/user.dart';
import 'package:impact/screens/home/add_emission.dart';
import 'package:impact/screens/home/charts/day_chart.dart';
import 'package:impact/screens/home/charts/insights_chart.dart';
import 'package:impact/screens/home/insights.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/services/auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:impact/services/database.dart';
import 'package:location/location.dart';

import 'package:provider/provider.dart';

class Impact extends StatefulWidget {
  @override
  _ImpactState createState() => _ImpactState();
}

class _ImpactState extends State<Impact> {
  final AuthService _auth = AuthService();

  bool show = false;
  int listIndex = 0;
  int totalEmissions = 0;
  List<Emission> newList;
  List<List<Emission>> dayList;
  List<Emission> empty = List<Emission>();

  @override
  Widget build(BuildContext context) {
    void _addEmission() {
      showModalBottomSheet(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          context: context,
          builder: (context) {
            return Container(
              height: 330,
              color: Colors.transparent,
              child: Container(
                height: 330,
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

    final user = Provider.of<User>(context);
    return FutureBuilder(
        future: DatabaseService(uid: user.uid).getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            newList = currentPeriod(userData.emissions);
            dayList = calcDay(userData);
            Widget chart =
                InsightsChart.loadData(newList, dayList[0], dayList[1]);
            return Container(
              height: MediaQuery.of(context).size.height - 84,
              child: Stack(children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 35),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Your impact levels are',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0)),
                                    Container(
                                        padding: EdgeInsets.all(0),
                                        width: 25,
                                        child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: () => _addEmission(),
                                          icon: Icon(Icons.add,
                                              color: Colors.white, size: 26.0),
                                        ))
                                  ]),
                              Text('Average',
                                  style: TextStyle(
                                      height: 0.5,
                                      color: Colors.yellow,
                                      fontSize: 16.0)),
                            ])),
                    Container(height: 335, width: 400, child: animation()),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            total(newList),
                            // SizedBox(height: 20),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: SizedBox(height: 200, child: chart)),
                          ],
                        )),
                  ],
                ),
              ]),
            );
          } else {
            return Container(height: 0);
          }
        });
  }

  Widget animation() {
    return Image.asset('assets/impact.gif',
        alignment: Alignment.center, fit: BoxFit.fitHeight);
  }

  Widget total(List<Emission> emissions) {
    for (var item in emissions) {
      if (listIndex < emissions.length) {
        totalEmissions += item.ghGas;
        listIndex++;
      }
    }

    return Container(
        height: 90,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Today\'s total:',
                style:
                    TextStyle(fontSize: 12, color: Colors.white, height: 0.9)),
            SizedBox(height: 3),
            Text(totalEmissions.toString(),
                style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 0.95)),
            Text('grams of greenhouse emissions',
                style:
                    TextStyle(fontSize: 12, color: Colors.white, height: 0.5)),
          ],
        ));
  }

  List<Emission> currentPeriod(List<Emission> emissions) {
    DateTime period = DateTime.now();
    List<Emission> timeList = new List<Emission>();
    List<Emission> dummy = new List<Emission>();

    if (emissions != null) {
      for (var i in emissions) {
        if ((i.time != null) &&
            (i.time.day == period.day) &&
            (i.time.month == period.month) &&
            (i.time.year == period.year)) {
          timeList.add(i);
        }
      }
      return timeList;
    } else {
      return dummy;
    }
  }

  List<List<Emission>> calcDay(UserData userData) {
    List<Emission> electric = new List<Emission>();
    List<Emission> energy = new List<Emission>();

    for (int i = 0; i < 24; i++) {
      var year = DateTime.now().year;
      var month = DateTime.now().month;
      var day = DateTime.now().day;

      var hour = new DateTime(year, month, day, i, 0);

      electric.add(
        Emission(
            time: hour,
            emissionIcon: 'flash_on',
            emissionName: 'Electricity',
            emissionType:
                (((userData.electric / 31) / 24).roundToDouble()).toString() +
                    ' KWh',
            ghGas: (((userData.electric * 300) ~/ 31) ~/ 24)),
      );

      energy.add(Emission(
          time: hour,
          emissionIcon: 'whatshot',
          emissionName: 'Gas',
          emissionType:
              (((userData.heating / 31) / 24).roundToDouble()).toString() +
                  " KWh",
          ghGas: (((userData.heating * 203) ~/ 31) ~/ 24)));
    }

    for (var i in electric) {
      if (i.time.isAfter(DateTime.now())) energy.remove(i);
    }
    for (var i in energy) {
      if (i.time.isAfter(DateTime.now())) electric.remove(i);
    }

    return [electric, energy];
  }
}
