import 'dart:math';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/semantics.dart';

double titleMarg = 50.0;
int impactBlue = 0xFF0A4BDF;

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginScreenState();
}

class _LoginScreenState extends StatefulWidget {
  @override
  Widget build(context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.3, 1],
                colors: [Colors.black, const Color(0xFF222359)])),
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            welcomeMessage(),
            Container(margin: EdgeInsets.only(top: titleMarg)),
            submitButton(),
            Container(margin: EdgeInsets.only(top: 13.0)),
            buttonRow(),
            Container(margin: EdgeInsets.only(top: 13.0)),
            seperatorLine(),
            emailField(),
            passwordField(),
            Container(margin: EdgeInsets.only(top: 13.0)),
            loginRow()
          ],
        ));
  }
}

void reduce() {
  titleMarg = 10;
}

Widget emailField() {
  return TextField(
      onTap: () => reduce(),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: 'you@example.com',
          labelText: 'Email:',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: new UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 1.0, style: BorderStyle.solid))));
}

Widget welcomeMessage() {
  return Container(
      child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text('Welcome to',
          style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2.0)),
      Text('Impact.',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2.0))
    ],
  ));
}

Widget passwordField() {
  return TextField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: 'Password',
          labelText: 'Password:',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: new UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 1.0, style: BorderStyle.solid))));
}

Widget submitButton() {
  return ButtonTheme(
      minWidth: 600,
      height: 44,
      child: RaisedButton(
        child: Text(
          'Sign in with Apple ',
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
        ),
        color: Colors.white,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
        onPressed: () {},
      ));
}

Widget buttonRow() {
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ButtonTheme(
            minWidth: 155,
            height: 44,
            child: RaisedButton(
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
              color: const Color(0xFF0A4BDF),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              onPressed: () {},
            )),
        ButtonTheme(
            minWidth: 155,
            height: 44,
            child: RaisedButton(
              child: Text(
                'Create Account',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
              color: const Color(0xFF0A4BDF),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              onPressed: () {},
            ))
      ]);
}

Widget seperatorLine() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Container(height: 1.5, color: const Color(0xFF0A4BDF), width: 150),
      Text('or', style: TextStyle(color: const Color(0xFF0A4BDF))),
      Container(height: 1.5, color: const Color(0xFF0A4BDF), width: 150),
    ],
  );
}

Widget loginRow() {
  return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Forgot Password?',
            style: TextStyle(color: const Color(0xFF0A4BDF))),
        ButtonTheme(
            minWidth: 155,
            height: 44,
            child: RaisedButton(
              child: Text(
                'Log In',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              ),
              color: const Color(0xFF0A4BDF),
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              onPressed: () {},
            ))
      ]);
}
