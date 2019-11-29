import 'package:flutter/material.dart';
import 'package:login_bloc/src/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_bloc/src/screens/login_screen.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: new Stack(
        children: <Widget>[
          _rootImage(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(height: 72),
              _logoTitle(),
              Container(height: 148),
              _ethosText(),
              Container(height: 268),
              _startButton(),
            ],
          )
        ],
      )),
    );
  }

  Widget _logoTitle() {
    return new Column(
      children: <Widget>[
        Image.asset(
          'assets/logo.png',
          width: 60,
          height: 60,
          color: Colors.white,
        ),
        Container(height: 5),
        Text('Impact', style: TextStyle(color: Colors.white, fontSize: 15)),
      ],
    );
  }

  Widget _ethosText() {
    return new Container(
      child: new Text('It’s time you changed the way you impact our planet.',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
      width: 280,
    );
  }

  Widget _startButton() {
    return new ButtonTheme(
        minWidth: 350,
        height: 44,
        child: RaisedButton(
            child: Text(
              'Get Started',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.normal),
            ),
            color: Colors.white,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(5.0),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            }));
  }

  Widget _rootImage() {
    Size size = MediaQuery.of(context).size;
    return new Image.asset(
      'assets/root-image.jpg',
      width: size.width,
      height: size.height,
      fit: BoxFit.fitHeight,
    );
  }
}
