import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Impact extends StatefulWidget {
  @override
  _ImpactState createState() => _ImpactState();
}

class _ImpactState extends State<Impact> {
  String impactLevel = "Average";
  final List<charts.Series> seriesList;
  final bool animate = false;
  // Color impactColour = Colors.yellow;
  int impactTotal = 2446;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[topBar(), planetEarth(), emissionTotal()],
            )));
  }

  Widget topBar() {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(top: 38),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Your impact levels are",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                    Icon(Icons.add, color: Colors.white),
                  ])),
          Text(
            impactLevel,
            style: TextStyle(
                color: Colors.yellowAccent,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ),
        ]);
  }

  Widget planetEarth() {
    return Container(
      child: Image.asset('assets/planet.png'),
    );
  }

  Widget emissionTotal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Today's total:",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        Text("$impactTotal",
            style: TextStyle(
                fontSize: 63,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1)),
        Text("grams of greenhouse emissions",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, height: 0.5))
      ],
    );
  }

  Widget dayGraph() {
    return new charts.LineChart(seriesList, animate: animate);
  }
}
