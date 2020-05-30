import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:impact/models/distance_matrix.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/home/group.dart';
import 'package:impact/screens/home/impact.dart';
import 'package:impact/screens/home/improve.dart';
import 'package:impact/screens/home/insights.dart';
import 'package:impact/screens/home/profile.dart';
import 'package:impact/screens/shared/constants.dart';
import 'package:impact/services/database.dart';
import 'package:latlong/latlong.dart' as lat;
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 2;
  int moving = 0;

  geo.Position position;
  geo.Position lastPosition;
  final lat.Distance distance = new lat.Distance();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: FutureBuilder<UserData>(
          future: DatabaseService(uid: user.uid).getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DatabaseService(uid: user.uid).checkUserDocumentExists();
              return Container(
                decoration: backgroundGradient,
                height: 800,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          showWidget(),
                        ]),
                  ),
                  bottomNavigationBar: CupertinoTabBar(
                      currentIndex: _index,
                      backgroundColor: Colors.transparent,
                      onTap: (val) => setState(() {
                            _index = val;
                            requestLocationPermission(context);
                          }),
                      activeColor: Colors.white,
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(Icons.group), title: Text('Group')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.nature_people),
                            title: Text('Improve')),
                        BottomNavigationBarItem(
                            icon: ImageIcon(
                                AssetImage('assets/impact-white.png')),
                            title: Text('Impact')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.timeline),
                            title: Text('Insights')),
                        BottomNavigationBarItem(
                            icon: Icon(Icons.person), title: Text('Profile')),
                      ]),
                ),
              );
            } else {
              return Container(height: 0);
            }
          }),
    );
  }

  Widget showWidget() {
    switch (_index) {
      case 0:
        return Group();
      case 1:
        return Improve();
      case 2:
        return Impact();
      case 3:
        return Insights();
      case 4:
        return Profile();
        break;
      default:
        return Impact();
    }
  }

  void requestLocationPermission(BuildContext context) async {
    geo.Position position = await geo.Geolocator()
        .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);

    if (lastPosition == null) {
      lastPosition = position;
      print(position.toString());
    } else {
      final double km = distance.as(
          lat.LengthUnit.Kilometer,
          new lat.LatLng(lastPosition.latitude, lastPosition.longitude),
          new lat.LatLng(position.latitude, position.longitude));

      if (km > 1) {
        moving++;
        if (moving > 2) {
          DistanceMatrix route = await DistanceMatrix.loadData(
              (lastPosition.latitude.toString() +
                  ',' +
                  lastPosition.longitude.toString()),
              (position.latitude.toString() +
                  ',' +
                  position.longitude.toString()));
          print(route.elements[0].distance.text);
        } else {
          print(position);
        }
      }
    }
  }
}
