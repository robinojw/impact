import 'package:flutter/material.dart';
import 'package:impact/screens/shared/constants.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> vehicles = [
    'Small Car',
    'Large Car',
    'Electric Car',
    'Motorbike',
    'Electric Bike',
    'Electric Scooter',
    'Van',
    'Lorry',
    'No vehicle'
  ];

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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text('Update your settings.', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: InputDecoration(hintText: 'Name'),
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    onChanged: (val) => setState(() => _currentVehicle = val),
                    value: _currentVehicle ?? userData.vehicle,
                    items: vehicles.map((vehicle) {
                      return DropdownMenuItem(
                        value: vehicle,
                        child: Text('$vehicle'),
                      );
                    }).toList(),
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
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
                            _currentCity ?? userData.city);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            print(snapshot);
            print('Cant get data');
            return Loading();
          }
        });
  }
}
