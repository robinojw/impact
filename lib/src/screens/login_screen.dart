import 'dart:developer';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:login_bloc/src/screens/create_account.dart';
import 'package:login_bloc/src/screens/app.dart';
import 'package:login_bloc/src/screens/root_page.dart';

import 'package:firebase_auth/firebase_auth.dart';

double titleMarg = 50.0;
int impactBlue = 0xFF0A4BDF;
int impactGreen = 0xFFCADD64;

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginScreenState();
}

enum FormType { login, register }

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;
  double topPadding = 149;
  bool pressed = false;

  final _formKey = new GlobalKey<FormState>();
//METHODS START

  Future<void> signIn() async {
    final formState = _formKey.currentState;
    //Validate fields
    if (formState.validate()) {
      formState.save();
      try {
        AuthResult result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        FirebaseUser user = result.user;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => App(user: user)));
      } catch (e) {
        print(e.message);
      }
    }
    //Login to firebase
  }

//METHODS END

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.3, 1],
                            colors: [Colors.black, const Color(0xFF222359)])),
                    padding:
                        EdgeInsets.only(top: topPadding, right: 20, left: 20),
                    height: size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        welcomeMessage(),
                        Container(margin: EdgeInsets.only(top: titleMarg)),
                        _showForm(),
                      ],
                    )))));
  }

  _shrinkPage() {
    if (!pressed)
      topPadding = 149;
    else
      topPadding = 50;

    log("hello");
  }

  Widget _showForm() {
    return new Container(
        child: Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                submitButton(),
                Container(margin: EdgeInsets.only(top: 13.0)),
                buttonRow(),
                Container(margin: EdgeInsets.only(top: 13.0)),
                seperatorLine(),
                emailField(),
                passwordField(),
                Container(margin: EdgeInsets.only(top: 13.0)),
                loginRow(),
              ],
            )));
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

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: 'you@example.com',
          labelText: 'Email:',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: new UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 1.0, style: BorderStyle.solid))),
      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      onSaved: (value) => _email = value.trim(),
      onTap: _shrinkPage(),
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      maxLines: 1,
      autofocus: false,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: 'Password',
          labelText: 'Password:',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: new UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 1.0, style: BorderStyle.solid))),
      validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
      onSaved: (value) => _password = value.trim(),
      onTap: _shrinkPage(),
    );
  }

  Widget submitButton() {
    return ButtonTheme(
        minWidth: 600,
        height: 44,
        child: RaisedButton(
          child: Text(
            'Sign in with Apple ',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.normal),
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
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateAccount()));
                },
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
                onPressed: signIn,
              ))
        ]);
  }
}
