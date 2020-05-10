import 'package:flutter/material.dart';
import 'package:impact/screens/shared/routing_constants.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background-large.jpg'),
              fit: BoxFit.fitHeight),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),

                //-----Icon and App Name----
                Column(children: <Widget>[
                  Image.asset('assets/impact-white.png'),
                  Text('Impact',
                      style: TextStyle(color: Colors.white, fontSize: 14))
                ]),

                SizedBox(height: 180),

                //-------Title-------------
                Text('It\'s time you changed the way you impact our planet.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),

                SizedBox(height: 300),

                //--------Button------------
                ButtonTheme(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  minWidth: 400,
                  height: 42.5,
                  child: FlatButton(
                    child: Text("Get Started",
                        style: TextStyle(fontWeight: FontWeight.w400)),
                    color: Colors.white,
                    textColor: Colors.black,
                    onPressed: () {
                      Navigator.pushNamed(context, register);
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
