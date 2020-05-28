import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:impact/screens/shared/constants.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/screens/shared/routing_constants.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';

class VehicleInfo extends StatefulWidget {
  @override
  _VehicleInfoState createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {
  final _formKey = GlobalKey<FormState>();

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

  final List<String> vehicles = [
    'I don\'t own a vehicle',
    'Car',
    'Motorbike',
    'Bicycle',
    'Scooter',
    'Skateboard',
  ];

  final List<String> fuels = [
    'Petrol',
    'Diesel',
    'Electric',
    'No engine or motor',
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return FutureBuilder<UserData>(
      future: DatabaseService(uid: user.uid).getUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          return Container(
            decoration: backgroundGradient,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                height: 800,
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 30),
                        Container(
                            width: 300,
                            child: Image.asset('assets/vehicle-info.png')),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 50),
                            Container(
                              width: 300,
                              child: Text(
                                'Tell us about your ride.',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                                'In order to make accurate calculations of each journey\'s emissions, we need some information about your primary vehicle',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 10)),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 20),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Vehicle Type',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          Theme(
                                            data: new ThemeData(
                                                canvasColor:
                                                    const Color(0XFF252740)),
                                            child: DropdownButtonFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: textInputDecoration,
                                              onChanged: (val) => setState(
                                                  () => _currentVehicle = val),
                                              value: _currentVehicle ??
                                                  userData.vehicle,
                                              items: vehicles.map((vehicle) {
                                                return DropdownMenuItem(
                                                  value: vehicle,
                                                  child: Text('$vehicle'),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ]),
                                    SizedBox(height: 20),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('Fuel Type',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          Theme(
                                            data: new ThemeData(
                                                canvasColor:
                                                    const Color(0XFF252740)),
                                            child: DropdownButtonFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: textInputDecoration,
                                              onChanged: (val) => setState(() {
                                                _currentFuel = val;
                                              }),
                                              value:
                                                  _currentFuel ?? userData.fuel,
                                              items: fuels.map((fuel) {
                                                return DropdownMenuItem(
                                                  value: fuel,
                                                  child: Text('$fuel'),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ]),
                                    SizedBox(height: 20),
                                    engineSize(_currentFuel),
                                    SizedBox(height: 20),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          ButtonTheme(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            minWidth: 130,
                                            height: 42.5,
                                            child: FlatButton(
                                              child: Text("Next",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              color: const Color(0XFF1451DB),
                                              textColor: Colors.white,
                                              onPressed: () async {
                                                Navigator.pushNamed(
                                                    context, energy);
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  await DatabaseService(
                                                          uid: user.uid)
                                                      .updateUserData(
                                                          _currentUsername ??
                                                              userData.username,
                                                          _currentName ??
                                                              userData.name,
                                                          _currentVehicle ??
                                                              userData.vehicle,
                                                          _currentFuel ??
                                                              userData.fuel,
                                                          _currentEngineSize ??
                                                              userData
                                                                  .engineSize,
                                                          _currentMpg ??
                                                              userData
                                                                  .vehicleMpg,
                                                          _currentEnergy ??
                                                              userData.energy,
                                                          _currentElectricity ??
                                                              userData
                                                                  .electricity,
                                                          _currentElectric ??
                                                              userData.electric,
                                                          _currentHeating ??
                                                              userData.heating,
                                                          _currentCommute ??
                                                              userData.commute,
                                                          emissions ??
                                                              userData
                                                                  .emissions,
                                                          _currentCity ??
                                                              userData.city);
                                                  //route to next page
                                                }
                                              },
                                            ),
                                          ),
                                        ]),
                                  ],
                                ))
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }

  Widget engineSize(String fuel) {
    if ((fuel == 'Petrol') || (fuel == 'Diesel')) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Text('Engine Size', style: TextStyle(color: Colors.grey, fontSize: 12)),
        TextFormField(
          style: TextStyle(color: Colors.white),
          decoration: textInputDecoration,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ],
          validator: (val) => val.isEmpty ? 'Please enter a engine size' : null,
          onChanged: (val) =>
              setState(() => _currentEngineSize = double.parse(val)),
        ),
      ]);
    } else {
      return Container(height: 0);
    }
  }
}
