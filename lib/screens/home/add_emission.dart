import 'package:flutter/material.dart';
import 'package:impact/models/user.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';

class AddEmission extends StatefulWidget {
  @override
  _AddEmissionState createState() => _AddEmissionState();
}

class _AddEmissionState extends State<AddEmission> {
  final _formKey = GlobalKey<FormState>();
  final List<String> emissionType = ["Travel", "Packaging"];
  String emissionValue;
  // String travelType;
  final List<String> travelList = [
    'Personal Vehicle',
    'Underground',
    'Bus',
    'Train',
    'Plane',
    'Motorbike',
    'Tram',
    'E-Bike',
    'E-Skateboard'
  ];

  final List<String> packaging = [
    'Coffee Cup',
    'Plastic Bottle',
    'Plastic Container',
    'Cardboard Box',
    'Plastic Wrapping',
    'Plastic Bag',
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

  String _emissionIcon;
  String _emissionName;
  String _emissionType;
  int _ghGas = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    bool weight;
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          emissions = userData.emissions;
          return Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Add an emission",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              Container(
                width: 340,
                child: DropdownButton(
                  isExpanded: true,
                  hint: Text("Emission Type"),
                  value: emissionValue,
                  items: emissionType.map((value) {
                    return DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      if (value == 'Travel') {
                        _emissionName = 'Personal Vehicle';
                      } else {
                        _emissionName = 'Coffee Cup';
                      }
                      emissionValue = value;
                    });
                  },
                ),
              ),
              travelEmission(userData),
              packagingEmission(userData, weight, user),
            ],
          ));
        });
  }

  Widget packagingEmission(UserData userData, bool weight, User user) {
    if (emissionValue == "Packaging") {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Container(
                width: 400,
                child: DropdownButton(
                  isExpanded: true,
                  hint: Text('Packaging type'),
                  value: _emissionName,
                  items: packaging.map((value) {
                    return DropdownMenuItem(
                      child: Text(value),
                      value: value,
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _emissionName = value;
                      if (_emissionName == 'Coffee Cup') {
                        _ghGas = calcImpact(0.0, 'Coffee Cup').toInt();
                      }
                      if (_emissionName == 'Plastic Bottle') {
                        _ghGas = calcImpact(0.0, 'Plastic Bottle').toInt();
                      }
                      if (_emissionName == 'Plastic Bag') {
                        _ghGas = calcImpact(0.0, 'Plastic Bottle').toInt();
                      }
                    });
                  },
                )),
            weightWidget(weight),
            SizedBox(height: 15),
            impactValue('Packaging Emissions: '),
            SizedBox(height: 20),
            submitButton(userData, user)
          ]);
    } else {
      return Container(height: 0);
    }
  }

  Widget weightWidget(bool weight) {
    int weightGrams = 0;

    if ((_emissionName == 'Plastic Container') ||
        (_emissionName == 'Cardboard Box') ||
        (_emissionName == 'Plastic Wrapping')) {
      weight = true;
    } else {
      weight = false;
    }

    if (weight == true) {
      return TextField(
          decoration: InputDecoration(
              hintText: 'Estimated weight in grams', helperText: 'grams'),
          onChanged: (val) => setState(() {
                weightGrams = int.parse(val);
                _ghGas =
                    calcImpact(weightGrams.toDouble(), _emissionName).toInt();
              }),
          keyboardType: TextInputType.number);
    } else {
      return Container(height: 0);
    }
  }

  Widget impactValue(String title) {
    return Center(
      child: Text(title + _ghGas.toString() + "g",
          style: TextStyle(
              color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget travelEmission(UserData userData) {
    final user = Provider.of<User>(context);
    if (emissionValue == "Travel") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
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
                });
              },
            ),
          ),
          SizedBox(height: 10),
          TextField(
              decoration: InputDecoration(hintText: 'Distance in miles'),
              onChanged: (val) => setState(() {
                    _emissionType = val;

                    _ghGas =
                        calcImpact(double.parse(_emissionType), _emissionName)
                            .toInt();
                  }),
              keyboardType: TextInputType.number),
          SizedBox(height: 15),
          impactValue('Travel Emissions: '),
          SizedBox(height: 15),
          submitButton(userData, user),
        ],
      );
    } else
      return Container(height: 0);
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
                    emissionIcon: _emissionIcon,
                    emissionName: _emissionName,
                    emissionType: _emissionType,
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
