import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:impact/models/distance_matrix.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/home/track.dart';
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
  final _formKey = GlobalKey<FormState>();
  int _index = 2;
  ScrollPhysics scroll;
  int moving = 0;
  bool popUp = false;
  bool isNumber(String item) {
    return '0123456789'.split('').contains(item);
  }

  final List<String> travelList = [
    'Personal Vehicle',
    'Car',
    'Underground',
    'Bus',
    'Train',
    'Plane',
    'Motorbike',
    'Tram',
    'E-Bike',
    'E-Skateboard'
  ];

  String _currentUsername;
  String _currentName;
  String _currentVehicle;
  String _currentFuel;
  double _currentEngineSize;
  int _currentMpg;
  String _currentEnergy;
  String _currentElectricity;
  double _currentElectric;
  double _currentHeating;
  String _currentCommute;
  List<Emission> emissions;
  String _currentCity;

  DateTime _time;
  String _emissionIcon;
  String _emissionName;
  String _emissionType;
  int _ghGas = 0;

  List<String> factor;

  geo.Position position;
  geo.Position lastPosition;
  geo.Position initialPosition;
  final lat.Distance distance = new lat.Distance();
  bool active = false;

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
              return Container(
                decoration: backgroundGradient,
                height: MediaQuery.of(context).size.height,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    physics: scroll,
                    child: Stack(children: <Widget>[
                      showWidget(),
                      popup(),
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
                            icon: Icon(Icons.gps_fixed), title: Text('Track')),
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
        scroll = NeverScrollableScrollPhysics();
        return Track();
      case 1:
        scroll = AlwaysScrollableScrollPhysics();
        return Improve();
      case 2:
        scroll = NeverScrollableScrollPhysics();
        return Impact();
      case 3:
        scroll = AlwaysScrollableScrollPhysics();
        return Insights();
      case 4:
        scroll = NeverScrollableScrollPhysics();
        return Profile();
        break;
      default:
        scroll = AlwaysScrollableScrollPhysics();
        return Impact();
    }
  }

  void requestLocationPermission(BuildContext context) async {
    geo.Position position = await geo.Geolocator()
        .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);

    if (initialPosition == null) {
      initialPosition = position;
    } else {
      final double km = distance.as(
          //Calculate distance between initial point and the current position
          lat.LengthUnit.Kilometer,
          new lat.LatLng(initialPosition.latitude, initialPosition.longitude),
          new lat.LatLng(position.latitude, position.longitude));
      if (km > 1) {
        //if the person is moving determine whether they have finished there
        //journey before calculating the route
        if (lastPosition != null) {
          final double km2 = distance.as(
              lat.LengthUnit.Kilometer,
              new lat.LatLng(lastPosition.latitude, lastPosition.longitude),
              new lat.LatLng(position.latitude, position.longitude));
          if (km2 <= 0.1) {
            DistanceMatrix route = await DistanceMatrix.loadData(
                (initialPosition.latitude.toString() +
                    ',' +
                    initialPosition.longitude.toString()),
                (position.latitude.toString() +
                    ',' +
                    position.longitude.toString()));

            factor = route.elements[0].distance.text.split(' ');

            popUp = true;
          }
        } else {
          lastPosition = position;
        }
      } else {
        print(km);
      }
    }
  }

  Widget popup() {
    if (popUp == true) {
      final user = Provider.of<User>(context);
      return FutureBuilder(
          future: DatabaseService(uid: user.uid).getUserData(),
          builder: (context, snapshot) {
            UserData userData = snapshot.data;
            emissions = userData.emissions;
            return Column(
              children: <Widget>[
                SizedBox(height: 250),
                AlertDialog(
                    contentPadding: EdgeInsets.all(15),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Add a journey?',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        Text(
                            'Impact detected a change in location, in order to calculate this journey\'s emissions we need to know the vehicle used.',
                            style: TextStyle(fontSize: 12)),
                        SizedBox(height: 15),
                        Container(
                          width: 400,
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text('Vehicle type'),
                            value: _emissionName,
                            items: travelList.map((value) {
                              return DropdownMenuItem(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _emissionName = value;
                                _ghGas = calcImpact((double.parse(factor[0])),
                                        _emissionName)
                                    .toInt();
                              });
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        submitButton(userData, user)
                      ],
                    )),
              ],
            );
          });
    } else {
      return Container(height: 0);
    }
  }

  Widget submitButton(UserData userData, User user) {
    return Align(
        alignment: Alignment.centerRight,
        child: ButtonTheme(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            minWidth: 400,
            height: 50,
            child: FlatButton(
              child: Text("Add Emission",
                  style: TextStyle(fontWeight: FontWeight.w400)),
              color: const Color(0XFF1451DB),
              textColor: Colors.white,
              onPressed: () async {
                emissions.add(new Emission(
                    time: DateTime.now(),
                    emissionIcon: _emissionIcon,
                    emissionName: _emissionName,
                    emissionType: (_emissionType.toString() + " Miles"),
                    ghGas: _ghGas));

                await DatabaseService(uid: user.uid).updateUserData(
                    _currentUsername ?? userData.username,
                    _currentName ?? userData.name,
                    _currentVehicle ?? userData.vehicle,
                    _currentFuel ?? userData.fuel,
                    _currentEngineSize ?? userData.engineSize,
                    _currentMpg ?? userData.vehicleMpg,
                    _currentEnergy ?? userData.energy,
                    _currentElectricity ?? userData.electricity,
                    _currentElectric ?? userData.electric,
                    _currentHeating ?? userData.heating,
                    _currentCommute ?? userData.commute,
                    emissions ?? userData.emissions,
                    _currentCity ?? userData.city);

                setState(() {
                  popUp = false;
                });
              },
            )));
  }

  double personalVehicle(UserData userData, double distance) {
    String carSize;
    double emissions;

    if ((userData.vehicle == 'Car') || (userData.vehicle == 'Motorbike')) {
      //Determine engine size and vehicle size
      if (userData.fuel == 'Petrol') {
        if (userData.engineSize <= 1.4) emissions = distance * 125.5;
        if (userData.engineSize > 1.4) emissions = distance * 163.3;
        if (userData.engineSize >= 2.0) emissions = distance * 247.7;
      }
      if (userData.fuel == 'Diesel') {
        if (userData.engineSize <= 1.7) emissions = distance * 110.6;
        if (userData.engineSize > 1.7) emissions = distance * 138.3;
        if (userData.engineSize >= 2.0) emissions = distance * 169.2;
      }
      if (userData.fuel == 'Electric') emissions = distance * 89;
    }
    if (userData.vehicle == 'Bicycle')
      emissions = calcImpact(distance, 'Bicycle');
    if (userData.vehicle == 'Scooter')
      emissions = calcImpact(distance, 'Scooter');
    if (userData.vehicle == 'Skateboard')
      emissions = calcImpact(distance, 'Skateboard');

    return emissions;
  }

  double calcImpact(double factor, String name) {
    double ghGas;
    switch (name) {
      case 'Plastic Bottle':
        _emissionIcon = 'battery_full';
        _emissionType = 'Polyethylene';
        return ghGas = 82;
      case 'Coffee Cup':
        _emissionIcon = 'local_cafe';
        _emissionType = "Plastic and Paper";
        return ghGas = 108;
      case 'Plastic Container':
        _emissionIcon = 'web_asset';
        _emissionType = 'Polyethylene';
        return ghGas = factor * 6;
      case 'Cardboard Box':
        _emissionIcon = 'archive';
        _emissionType = 'Cardboard and Paper';
        return ghGas = factor * 3;
      case 'Plastic Wrapping':
        _emissionIcon = 'layers';
        _emissionType = 'Low-Density Polyethylene';
        return ghGas = factor * 6;
      case 'Plastic Bag':
        _emissionIcon = 'shopping_basket';
        _emissionType = 'Polyethylene';
        return ghGas = 50.0 * 6.0;
      case 'Underground':
        _emissionIcon = "directions_subway";
        _emissionType = factor.toString();
        return ghGas = factor * 34;
      case 'Car':
        _emissionIcon = "directions_car";
        _emissionType = factor.toString();
        return ghGas = factor * 138;
      case 'Bus':
        _emissionIcon = 'directions_bus';
        _emissionType = factor.toString();
        return ghGas = factor * 166;
      case 'Train':
        _emissionIcon = 'train';
        _emissionType = factor.toString();
        return ghGas = factor * 56;
      case 'Plane':
        _emissionIcon = 'flight';
        _emissionType = factor.toString();
        return ghGas = factor * 122;
      case 'Motorbike':
        _emissionIcon = 'motorcycle';
        _emissionType = factor.toString();
        return ghGas = factor * 77;
      case 'Tram':
        _emissionIcon = 'tram';
        _emissionType = factor.toString();
        return ghGas = factor * 56;
      case 'E-Bike':
        _emissionIcon = 'directions_bicycle';
        _emissionType = factor.toString();
        return ghGas = factor * 3;
      case 'E-Skateboard':
        _emissionIcon = 'filter_drama';
        _emissionType = factor.toString();
        return ghGas = factor * 3;
        break;
      default:
        ghGas = 0;
    }
  }
}
