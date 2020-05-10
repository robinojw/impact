import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:impact/screens/shared/constants.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/screens/shared/routing_constants.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';

class EnergyInfo extends StatefulWidget {
  @override
  _EnergyInfoState createState() => _EnergyInfoState();
}

class _EnergyInfoState extends State<EnergyInfo> {
  final _formKey = GlobalKey<FormState>();

  String _currentUsername;
  String _currentName;
  String _currentVehicle;
  String _currentFuel;
  int _currentEngineSize;
  int _currentMpg;
  String _currentEnergy;
  String _currentElectricity;
  int _currentElectric;
  int _currentHeating;
  String _currentCommute;
  String _currentCity;

  bool _value = false;

  final List<String> energySources = [
    'Gas',
    'Oil',
    'Solar',
    'Wood Burner',
    'Passive/Insulation'
  ];

  final List<String> electricitySources = [
    'Grid',
    'Renewable Grid',
    'Solar',
    'Wind',
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
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
                            child: Image.asset('assets/energy-info.png')),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 40),
                            Container(
                              width: 300,
                              child: Text(
                                'Where do you get your energy?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                                'We use your energy sources and types to better calculate your monthly emissions.',
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
                                          Text('Heating Energy Type',
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
                                                  () => _currentEnergy = val),
                                              value: _currentEnergy ??
                                                  userData.energy,
                                              items:
                                                  energySources.map((energy) {
                                                return DropdownMenuItem(
                                                  value: energy,
                                                  child: Text('$energy'),
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
                                          Text('Electricity Source',
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
                                              onChanged: (val) => setState(() =>
                                                  _currentElectricity = val),
                                              value: _currentElectricity ??
                                                  userData.electricity,
                                              items: electricitySources
                                                  .map((electricity) {
                                                return DropdownMenuItem(
                                                  value: electricity,
                                                  child: Text('$electricity'),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ]),
                                    SizedBox(height: 10),
                                    ListTile(
                                      title: Text(
                                          'Do you know your energy usage in KWh?',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                      leading: Theme(
                                        data: ThemeData(
                                          unselectedWidgetColor: Colors.white,
                                        ),
                                        child: Checkbox(
                                            value: _value,
                                            onChanged: (bool value) {
                                              setState(() {
                                                _value = value;
                                              });
                                            }),
                                      ),
                                    ),
                                    if (_value == true)
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Heating Usage in KWh',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12)),
                                            TextFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: textInputDecoration,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              validator: (val) => val.isEmpty
                                                  ? 'Please enter your heating usage in KWh'
                                                  : null,
                                              onChanged: (val) => setState(
                                                () => _currentHeating =
                                                    int.parse(val),
                                              ),
                                            ),
                                          ]),
                                    SizedBox(height: 20),
                                    if (_value == true)
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Electricity Usage in KWh',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12)),
                                            TextFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: textInputDecoration,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              validator: (val) => val.isEmpty
                                                  ? 'Please enter your electricity usage in KWh'
                                                  : null,
                                              onChanged: (val) => setState(
                                                () => _currentElectric =
                                                    int.parse(val),
                                              ),
                                            ),
                                          ]),
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
                                                          _currentCity ??
                                                              userData.city);
                                                  Navigator.pushNamed(
                                                      context, home);
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
}
