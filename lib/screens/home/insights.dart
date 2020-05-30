import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/home/charts/insights_chart.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Insights extends StatefulWidget {
  @override
  _InsightsState createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  int currentTab = 0;
  double totalEmissions = 0;
  double averageEmissions = 0;
  double containerHeight = 0;
  int listIndex = 0;

  var weight = 'grams';
  double difference = 0;

  List<Emission> newList;
  List<List<Emission>> dayList;
  List<Emission> emissionList;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return FutureBuilder<UserData>(
        future: DatabaseService(uid: user.uid).getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            emissionList = userData.emissions;
            emissionList = addEnergy(userData, emissionList);
            newList = currentPeriod(currentTab, userData.emissions);
            dayList = calcDay(userData);
            Widget insightsChart =
                InsightsChart.loadData(newList, dayList[0], dayList[1]);

            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  SizedBox(height: 40),
                  viewSlider(userData.emissions),
                  SizedBox(height: 10),
                  Container(height: 220, child: insightsChart),
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
                      height: containerHeight, child: cardList(emissionList)),
                ]),
              ),
            );
          } else {
            return Container(height: 0);
          }
        });
  }

  Widget viewSlider(List<Emission> emissions) {
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

  Widget leftCard(UserData userData) {
    if (averageEmissions == 0) {
      averageEmissions = 20000;
    }

    for (var item in newList) {
      if (listIndex < newList.length) {
        totalEmissions += item.ghGas;
        listIndex++;
      }
    }

    double emissionNum = totalEmissions;
    double remaining = 0;

    if (totalEmissions > 9999) {
      weight = 'Kilograms';
      emissionNum = totalEmissions / 1000;
      remaining = (averageEmissions / 1000) - totalEmissions;
    } else {
      var remaining = averageEmissions - totalEmissions;
    }

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
                    child: Text(emissionNum.toStringAsFixed(1),
                        style: TextStyle(
                            height: 1.1,
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: Text(weight,
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
                          remaining,
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
    Color color = Color(0xFFBCC158);
    String prefix = '-';

    double emissionNum = totalEmissions;
    double remaining = 0;
    double average = 0;

    if (averageEmissions > 9999) {
      weight = 'Kilograms';
      average = averageEmissions / 1000;
    }

    if (totalEmissions > averageEmissions) {
      color = Color(0xFFDB4545);
      prefix = "+";
      difference = ((totalEmissions - averageEmissions) / 1000);
      if (difference > 9999) difference = difference / 1000;
    } else {
      color = Color(0xFFBCC158);
      prefix = '-';
      difference = averageEmissions - totalEmissions;
      if (difference > 9999) difference = difference / 1000;
    }

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
                    child: Text(average.toStringAsFixed(1),
                        style: TextStyle(
                            height: 1.1,
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: Text(weight,
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
            child: Text(prefix + (difference.toStringAsFixed(1)),
                style: TextStyle(color: color, fontSize: 26)),
          )
        ]));
  }

  //------Card List---------
  Widget cardList(List<Emission> emissionList) {
    if (emissionList.isNotEmpty) {
      containerHeight = 70 * emissionList.length.toDouble();
      return ListView.builder(
        padding: EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: emissionList.length,
        itemBuilder: (context, index) {
          return cardTile(emissionList[index], emissionList.length);
        },
      );
    } else {
      containerHeight = 75;
      return Container(
        width: 400,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xD9252740)),
        child: Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: Center(
              child: Text('No Emissions Data',
                  style: TextStyle(color: Colors.white)),
            )),
      );
    }
  }

  //------Card Tile---------
  Widget cardTile(Emission emission, int length) {
    Icon _emissionIcon;

    _emissionIcon = getIcon(emission.emissionIcon);

    return Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: Card(
          margin: EdgeInsets.only(top: 1.5, left: 0, right: 0, bottom: 1.5),
          color: const Color(0xD9252740),
          child: ListTile(
            dense: true,
            leading: _emissionIcon,
            title: Text(emission.emissionName,
                style: TextStyle(color: Colors.grey)),
            subtitle: Text(emission.emissionType,
                style: TextStyle(color: Colors.white)),
            trailing: Text(emission.ghGas.toString() + "g",
                style: TextStyle(color: const Color(0xFFDB4545))),
          ),
        ));
  }

  List<Emission> currentPeriod(int tab, List<Emission> emissions) {
    DateTime period = DateTime.now();
    List<Emission> timeList = new List<Emission>();
    List<Emission> dummy = new List<Emission>();

    if (emissions != null) {
      if (tab == 0) {
        for (var i in emissions) {
          if ((i.time != null) &&
              (i.time.day == period.day) &&
              (i.time.month == period.month) &&
              (i.time.year == period.year)) {
            timeList.add(i);
          }
        }
      }
      if (tab == 1) {
        int weekNumber(DateTime date) {
          int dayOfYear = int.parse(DateFormat("D").format(date));
          return ((dayOfYear - date.weekday + 10) / 7).floor();
        }

        for (var i in emissions) {
          var eWeek = weekNumber(i.time);
          var thisWeek = weekNumber(period);
          if ((i.time != null) &&
              (eWeek == thisWeek) &&
              (i.time.year == period.year)) {
            timeList.add(i);
          }
        }
      }
      if (tab == 2) {
        for (var i in emissions) {
          if ((i.time != null) &&
              (i.time.month == period.month) &&
              (i.time.year == period.year)) {
            timeList.add(i);
          }
        }
      }
      if (tab == 3) {
        for (var i in emissions) {
          if ((i.time != null) && (i.time.year == period.year)) timeList.add(i);
        }
      }
      return timeList;
    } else
      return dummy;
  }

  List<Emission> addEnergy(UserData userData, List<Emission> list) {
    list.add(
      Emission(
          time: DateTime.now(),
          emissionIcon: 'flash_on',
          emissionName: 'Electricity',
          emissionType:
              ((userData.electric / 31).roundToDouble()).toString() + ' KWh',
          ghGas: (userData.electric * 300) ~/ 31),
    );

    list.add(Emission(
        time: DateTime.now(),
        emissionIcon: 'whatshot',
        emissionName: 'Gas',
        emissionType:
            ((userData.heating / 31).roundToDouble()).toString() + " KWh",
        ghGas: (userData.heating * 203) ~/ 31));

    return list;
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

  Icon getIcon(String icon) {
    switch (icon) {
      case 'flash_on':
        return Icon(
          Icons.flash_on,
          color: Colors.grey,
          size: 29,
        );
      case 'whatshot':
        return Icon(
          Icons.whatshot,
          color: Colors.grey,
          size: 29,
        );
      case 'Bicycle':
        return Icon(
          Icons.directions_bike,
          color: Colors.white,
          size: 29,
        );
      case 'Underground':
        return Icon(
          Icons.directions_subway,
          color: Colors.white,
          size: 29,
        );
      case 'Bus':
        return Icon(
          Icons.directions_bus,
          color: Colors.white,
          size: 29,
        );
      case 'Train':
        return Icon(
          Icons.train,
          color: Colors.white,
          size: 29,
        );
      case 'Car':
        return Icon(
          Icons.directions_car,
          color: Colors.white,
          size: 29,
        );
      case 'directions_bike':
        return Icon(
          Icons.directions_bike,
          color: Colors.grey,
          size: 29,
        );
      case 'directions_subway':
        return Icon(
          Icons.directions_subway,
          color: Colors.grey,
          size: 29,
        );
      case 'directions_bus':
        return Icon(
          Icons.directions_bus,
          color: Colors.grey,
          size: 29,
        );
      case 'train':
        return Icon(
          Icons.train,
          color: Colors.grey,
          size: 29,
        );
      case 'directions_car':
        return Icon(
          Icons.directions_car,
          color: Colors.grey,
          size: 29,
        );
      case 'directions_boat':
        return Icon(
          Icons.directions_boat,
          color: Colors.grey,
          size: 29,
        );
      case 'motorcycle':
        return Icon(
          Icons.motorcycle,
          color: Colors.grey,
          size: 29,
        );
      case 'tram':
        return Icon(
          Icons.tram,
          color: Colors.grey,
          size: 29,
        );
      case 'flight':
        return Icon(
          Icons.flight,
          color: Colors.grey,
          size: 29,
        );
      case 'battery_full':
        return Icon(
          Icons.battery_full,
          color: Colors.grey,
          size: 29,
        );
      case 'local_cafe':
        return Icon(
          Icons.local_cafe,
          color: Colors.grey,
          size: 29,
        );
      case 'web_asset':
        return Icon(
          Icons.web_asset,
          color: Colors.grey,
          size: 29,
        );
      case 'archive':
        return Icon(
          Icons.archive,
          color: Colors.grey,
          size: 29,
        );
      case 'layers':
        return Icon(
          Icons.layers,
          color: Colors.grey,
          size: 29,
        );
      case 'shopping_basket':
        return Icon(
          Icons.shopping_basket,
          color: Colors.grey,
          size: 29,
        );
        break;
      default:
        return Icon(
          Icons.filter_drama,
          color: Colors.grey,
          size: 29,
        );
    }
  }
}
