import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/home/charts/insights_chart.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';

class Insights extends StatefulWidget {
  @override
  _InsightsState createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();
  Widget insightsChart = InsightsChart.withSampleData();
  int currentTab = 0;
  double totalEmissions = 0;
  double averageEmissions = 0;
  double containerHeight = 0;
  int listIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  SizedBox(height: 40),
                  viewSlider(),
                  SizedBox(height: 10),
                  Container(height: 200, child: insightsChart),
                  SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        leftCard(userData),
                        SizedBox(width: 5),
                        rightCard(userData),
                      ]),
                  SizedBox(height: 20),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Today's Emissions",
                          style: TextStyle(color: Colors.white, fontSize: 14))),
                  SizedBox(height: 10),
                  SizedBox(
                      height: containerHeight,
                      child: cardList(userData.emissions)),
                ]),
              ),
            );
          } else {
            return Container(height: 0);
          }
        });
  }

  Widget viewSlider() {
    Widget tab(String view, int tab) {
      return GestureDetector(
        onTap: () {
          setState(() {
            currentTab = tab;
          });
        },
        child: Container(
            width: 100,
            child: Text(view,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white))),
      );
    }

    final Map<int, Widget> tabs = <int, Widget>{
      0: tab("D", 0),
      1: tab("W", 1),
      2: tab("M", 2),
      3: tab("Y", 3)
    };

    return CupertinoSlidingSegmentedControl(
        thumbColor: const Color(0xFF838383),
        groupValue: currentTab,
        children: tabs,
        onValueChanged: (int newVal) {
          setState(() {
            currentTab = newVal;
          });
        });
  }

  Widget leftCard(UserData user) {
    // for (int i = 0; i < user.emissions.length; i++) {
    //   totalEmissions += user.emissions[i].ghGas;
    // }
    return Container(
        decoration: BoxDecoration(
            color: const Color(0xD9252740),
            borderRadius: BorderRadius.circular(5)),
        width: 170,
        height: 129,
        padding: EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.all(0),
            width: 170,
            height: 66,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Total emissions",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            height: 1,
                            fontSize: 12,
                            color: const Color(0xFF838383))),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text((totalEmissions.toInt()).toString(),
                        style: TextStyle(
                            height: 1.1,
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: Text("grams",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            height: 0.8,
                            fontSize: 12,
                            color: const Color(0xFF838383))),
                  ),
                ]),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Align(
              heightFactor: 0.7,
              widthFactor: 0.7,
              child: new AnimatedCircularChart(
                  percentageValues: false,
                  key: _chartKey,
                  holeRadius: 13,
                  duration: Duration(milliseconds: 400),
                  edgeStyle: SegmentEdgeStyle.round,
                  chartType: CircularChartType.Radial,
                  size: const Size(75.0, 75.0),
                  initialChartData: <CircularStackEntry>[
                    new CircularStackEntry(
                      <CircularSegmentEntry>[
                        new CircularSegmentEntry(
                          totalEmissions,
                          const Color(0xFFBCC158),
                          rankKey: 'completed',
                        ),
                        new CircularSegmentEntry(
                          averageEmissions - totalEmissions,
                          const Color(0xFF3C3E4A),
                          rankKey: 'remaining',
                        )
                      ],
                      rankKey: 'progress',
                    )
                  ]),
            ),
          )
        ]));
  }

  Widget rightCard(userData) {
    return Container(
        decoration: BoxDecoration(
            color: const Color(0xD9252740),
            borderRadius: BorderRadius.circular(5)),
        width: 170,
        height: 129,
        padding: EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.all(0),
            height: 66,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Daily average",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            height: 1,
                            fontSize: 12,
                            color: const Color(0xFF838383))),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text((averageEmissions.toInt()).toString(),
                        style: TextStyle(
                            height: 1.1,
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: Text("grams",
                        style: TextStyle(
                            height: 0.8,
                            fontSize: 12,
                            color: const Color(0xFF838383))),
                  ),
                ]),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
                "-" +
                    (averageEmissions.toInt() - totalEmissions.toInt())
                        .toString(),
                style: TextStyle(color: const Color(0xFFBCC158), fontSize: 26)),
          )
        ]));
  }

  //------Card List---------
  Widget cardList(List<Emission> emissionList) {
    containerHeight = 70 * emissionList.length.toDouble();

    if (emissionList != null) {
      return ListView.builder(
        padding: EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: emissionList.length,
        itemBuilder: (context, index) {
          return cardTile(emissionList[index], emissionList.length);
        },
      );
    } else {
      return Container(height: 0);
    }
  }

  //------Card Tile---------
  Widget cardTile(emission, int length) {
    if (listIndex != length) {
      totalEmissions += emission.ghGas;
      listIndex++;
    }

    if (averageEmissions == 0) {
      averageEmissions = 3520;
    }

    return Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: Card(
          margin: EdgeInsets.only(top: 1.5, left: 0, right: 0, bottom: 1.5),
          color: const Color(0xD9252740),
          child: ListTile(
            dense: true,
            leading: Icon(
              Icons.directions_car,
              color: Colors.grey,
              size: 29,
            ),
            title: Text(emission.emissionName,
                style: TextStyle(color: Colors.grey)),
            subtitle: Text(emission.emissionType,
                style: TextStyle(color: Colors.white)),
            trailing: Text(emission.ghGas.toString() + "g",
                style: TextStyle(color: const Color(0xFFDB4545))),
          ),
        ));
  }
}
