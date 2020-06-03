import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:impact/models/distance_matrix.dart';
import 'package:impact/models/user.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';
import 'package:impact/screens/shared/constants.dart';

class SubmitTrip extends StatefulWidget {
  final String distance;
  final String time;

  const SubmitTrip({Key, key, this.distance, this.time}) : super(key: key);
  @override
  _SubmitTripState createState() => _SubmitTripState();
}

class _SubmitTripState extends State<SubmitTrip> {
  final _formKey = GlobalKey<FormState>();
  // String travelType;

  String distance = SubmitTrip().distance;
  String time = SubmitTrip().time;
  bool carSelected = true;

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

  DistanceMatrix distanceMatrix = new DistanceMatrix();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    bool weight;
    return Container(
      height: 800,
      color: Colors.transparent,
      child: Container(
        height: 800,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        child: FutureBuilder<UserData>(
            future: DatabaseService(uid: user.uid).getUserData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData userData = snapshot.data;
                emissions = userData.emissions;
                return SingleChildScrollView(
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Trip Details',
                          style: TextStyle(
                              color: const Color(0xFF252740),
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      SizedBox(height: 20),
                      totalDistance(),
                      SizedBox(height: 15),
                      vehicles(),
                      SizedBox(height: 15),
                      myVehicle(),
                      SizedBox(height: 15),
                      submitButton(userData, user)
                    ],
                  )),
                );
              } else {
                return Container(height: 0);
              }
            }),
      ),
    );
  }

  Widget vehicles() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            vehicleIcon(
                'Car',
                Icon(Icons.directions_car, color: Colors.white, size: 40),
                true),
            vehicleIcon(
                'Bus',
                Icon(Icons.directions_bus,
                    color: const Color(0xFF8a8a8a), size: 40),
                false),
            vehicleIcon(
                'Train',
                Icon(Icons.train, color: const Color(0xFF8a8a8a), size: 40),
                false),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            vehicleIcon(
                'Subway',
                Icon(Icons.subway, color: const Color(0xFF8a8a8a), size: 40),
                false),
            vehicleIcon(
                'E-Bike',
                Icon(Icons.directions_bike,
                    color: const Color(0xFF8a8a8a), size: 40),
                false),
            vehicleIcon(
                'Tram',
                Icon(Icons.tram, color: const Color(0xFF8a8a8a), size: 40),
                false),
          ],
        ),
      ],
    );
  }

  Widget vehicleIcon(String transport, Icon icon, bool selected) {
    Color colour = const Color(0XFFe1e7f0);
    Color textcolour = const Color(0xFF8a8a8a);

    Color containerColour = Colors.transparent;

    if (selected == true) {
      colour = const Color(0xFF252740);
      textcolour = Colors.white;
    }

    return Container(
        decoration: BoxDecoration(
            color: colour, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            icon,
            Text(transport,
                style: TextStyle(color: textcolour, fontSize: 12, height: 0.8))
          ],
        ),
        height: 70,
        width: 105);
  }

  Widget totalDistance() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Total distance',
            style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
                fontSize: 16)),
        Container(
            height: 55,
            width: 160,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0XFFe1e7f0)),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('110 Miles',
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 16))))),
      ],
    );
  }

  Widget myVehicle() {
    Color colour = const Color(0xFF8a8a8a);
    if (carSelected == true) {
      return Container(
        width: 340,
        height: 55,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0XFFe1e7f0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Icons.directions_car, color: colour, size: 30),
            Text('Petrol Engine  1.6L  45Mpg', style: TextStyle(color: colour)),
            Icon(Icons.chevron_right, color: colour),
          ],
        ),
      );
    } else {
      return Container(height: 0);
    }
  }

  Widget impactValue(String title) {
    String suffix;
    String displayValue;
    Color colour;

    if (_ghGas > 1000) {
      displayValue = (_ghGas / 1000).toString();
      suffix = 'KG';
      colour = Colors.orange;
    } else {
      suffix = 'g';
      displayValue = (_ghGas).toString();
      colour = Colors.green;
    }
    if (_ghGas > 1500) colour = Colors.deepOrange;
    if (_ghGas > 2000) colour = Colors.red;

    return Center(
      child: Text(title + displayValue.toString() + suffix,
          style: TextStyle(
              color: colour, fontSize: 14, fontWeight: FontWeight.bold)),
    );
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
                    emissionIcon: "directions_car",
                    emissionName: 'Car Journey',
                    emissionType: ("110 Miles"),
                    ghGas: 13200));

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

                Navigator.pop(context);
              },
            )));
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
        _emissionType = factor.toString() + ' Miles';
        return ghGas = factor * 34;
      case 'Bus':
        _emissionIcon = 'directions_bus';
        _emissionType = factor.toString() + ' Miles';
        return ghGas = factor * 166;
      case 'Train':
        _emissionIcon = 'train';
        _emissionType = factor.toString() + ' Miles';
        return ghGas = factor * 56;
      case 'Plane':
        _emissionIcon = 'flight';
        _emissionType = factor.toString() + ' Miles';
        return ghGas = factor * 122;
      case 'Motorbike':
        _emissionIcon = 'motorcycle';
        _emissionType = factor.toString() + ' Miles';
        return ghGas = factor * 77;
      case 'Tram':
        _emissionIcon = 'tram';
        _emissionType = factor.toString() + ' Miles';
        return ghGas = factor * 56;
      case 'E-Bike':
        _emissionIcon = 'directions_bicycle';
        _emissionType = factor.toString() + ' Miles';
        return ghGas = factor * 3;
      case 'E-Skateboard':
        _emissionIcon = 'filter_drama';
        _emissionType = factor.toString() + ' Miles';
        return ghGas = factor * 3;
        break;
      default:
        ghGas = 0;
    }
  }
}
