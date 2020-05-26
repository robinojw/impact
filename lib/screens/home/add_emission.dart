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
  final List<String> emissionType = ["Travel", "Product", "Packaging"];
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

  String _emissionIcon;
  String _emissionName;
  String _emissionType;
  int _ghGas;

  @override
  Widget build(BuildContext context) {
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
                emissionValue = value;
              });
            },
          ),
        ),
        travelEmission(),
      ],
    ));
  }

  Widget travelEmission() {
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
              onChanged: (val) => setState(() => _emissionType = val),
              keyboardType: TextInputType.number),
          SizedBox(height: 50),
          StreamBuilder<UserData>(
              stream: DatabaseService().userData,
              builder: (context, snapshot) {
                UserData userData = snapshot.data;
                return Align(
                    alignment: Alignment.centerRight,
                    child: ButtonTheme(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        minWidth: 400,
                        height: 50,
                        child: FlatButton(
                          child: Text("Add Emission",
                              style: TextStyle(fontWeight: FontWeight.w400)),
                          color: const Color(0XFF1451DB),
                          textColor: Colors.white,
                          onPressed: () async {},
                        )));
              }),
        ],
      );
    } else
      return Container(height: 0);
  }
}
