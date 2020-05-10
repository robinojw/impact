import 'package:flutter/material.dart';
import 'package:impact/services/auth.dart';

class Impact extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Your impact levels are',
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
              Icon(
                Icons.add,
                color: Colors.white,
                size: 24.0,
              )
            ],
          ),
          Text('Average',
              style: TextStyle(color: Colors.yellow, fontSize: 16.0)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Today\'s total:',
                  style: TextStyle(
                      fontSize: 12, color: Colors.white, height: 0.9)),
              Text('2446',
                  style: TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 0.95)),
              Text('grams of greenhouse emissions',
                  style: TextStyle(
                      fontSize: 12, color: Colors.white, height: 0.5)),
            ],
          ),
          SizedBox(
              height: 50,
              width: 150,
              child: RaisedButton(
                child: Text('Log Out'),
                onPressed: () {
                  _auth.signOut();
                },
              )),
        ],
      ),
    );
  }
}
