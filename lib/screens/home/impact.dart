import 'package:flutter/material.dart';
import 'package:impact/screens/home/add_emission.dart';
import 'package:impact/screens/home/charts/day_chart.dart';
import 'package:impact/services/auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Impact extends StatefulWidget {
  @override
  _ImpactState createState() => _ImpactState();
}

class _ImpactState extends State<Impact> {
  final AuthService _auth = AuthService();
  Widget chart = DayChart.withSampleData();
  bool show = false;

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
          ],
        ),
        SizedBox(height: 20),
        Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(height: 175, child: chart)),
      ]),
    );
  }
}
