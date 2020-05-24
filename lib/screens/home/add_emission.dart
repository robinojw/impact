import 'package:flutter/material.dart';
import 'package:impact/models/user.dart';
import 'package:provider/provider.dart';

class AddEmission extends StatefulWidget {
  @override
  _AddEmissionState createState() => _AddEmissionState();
}

class _AddEmissionState extends State<AddEmission> {
  final _formKey = GlobalKey<FormState>();
  final List<String> emissionType = ["Travel", "Product", "Packaging"];
  String emissionValue;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Add an emission", style: TextStyle(fontSize: 16)),
        SizedBox(height: 10),
        Container(
          width: 340,
          child: DropdownButton(
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
        // if(emissionType == "Travel"){
        //   //add travel options here
        // }
        // if(emissionType == "Product"){
        //   //Product options
        // }
        // if(emissionType == "Packaging"){
        //   //Packaging types, weight etc
        // }
        RaisedButton(color: Colors.lightBlue, child: Text('Add Emission')),
      ],
    ));
  }
}
