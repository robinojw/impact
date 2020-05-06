import 'package:flutter/material.dart';
import 'package:impact/screens/shared/constants.dart';
import 'package:impact/services/auth.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: backgroundGradient,
        child: RaisedButton(
          onPressed: () {
            _auth.signOut();
          },
        ));
  }
}
