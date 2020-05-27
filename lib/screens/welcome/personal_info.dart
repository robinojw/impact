import 'package:flutter/material.dart';
import 'package:impact/screens/shared/constants.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/screens/shared/routing_constants.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
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

  final List<String> commutes = [
    'I don\'t commute to work or school',
    'Bus',
    'Train',
    'Underground',
    'Personal Transport',
    'Carpool',
    'Airplane',
  ];

  @override
  Widget build(BuildContext context) {
    const timer = const Duration(seconds: 1);
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          return Container(
            decoration: backgroundGradient,
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                height: 800,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 30),
                          Container(
                              width: 300,
                              child: Image.asset('assets/personal-info.png')),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 20),
                              Container(
                                width: 300,
                                child: Text(
                                  'We need to know some information about you first...',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                  'before we start calculating your daily emissions we need to know a some information about your travel and energy uses.',
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
                                          Text('Username',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                          TextFormField(
                                            style:
                                                TextStyle(color: Colors.white),
                                            decoration: textInputDecoration,
                                            validator: (val) => val.isEmpty
                                                ? 'Please enter a username'
                                                : null,
                                            onChanged: (val) => setState(
                                                () => _currentUsername = val),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Full Name',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12)),
                                            TextFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: textInputDecoration,
                                              validator: (val) => val.isEmpty
                                                  ? 'Please enter a name'
                                                  : null,
                                              onChanged: (val) => setState(
                                                  () => _currentName = val),
                                            ),
                                          ]),
                                      SizedBox(height: 20),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Commute Type',
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
                                                    () =>
                                                        _currentCommute = val),
                                                value: _currentCommute ??
                                                    userData.commute,
                                                items: commutes.map((commute) {
                                                  return DropdownMenuItem(
                                                    value: commute,
                                                    child: Text('$commute'),
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
                                            Text('City or Location',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12)),
                                            TextFormField(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: textInputDecoration,
                                              validator: (val) => val.isEmpty
                                                  ? 'Please enter a city/location'
                                                  : null,
                                              onChanged: (val) => setState(
                                                  () => _currentCity = val),
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
                                                  Navigator.pushNamed(
                                                      context, vehicle);
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    await DatabaseService(
                                                            uid: user.uid)
                                                        .updateUserData(
                                                            _currentUsername ??
                                                                userData
                                                                    .username,
                                                            _currentName ??
                                                                userData.name,
                                                            _currentVehicle ??
                                                                userData
                                                                    .vehicle,
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
                                                                userData
                                                                    .electric,
                                                            _currentHeating ??
                                                                userData
                                                                    .heating,
                                                            _currentCommute ??
                                                                userData
                                                                    .commute,
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
            ),
          );
        } else {
          print('personal info loading');
          return Loading();
        }
      },
    );
  }
}
