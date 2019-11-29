import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_obj/flutter_3d_obj.dart';
import 'package:login_bloc/src/screens/impact_screen.dart';
import 'package:login_bloc/my_flutter_app_icons.dart';

class App extends StatefulWidget {
  const App({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int selectedPage = 2; //Initial page is always set to the impact view

  final pageOptions = [
    Text("Item 1", style: TextStyle(fontSize: 38)),
    Text("Item 2", style: TextStyle(fontSize: 38)),
    Impact(),
    Text("Item 4", style: TextStyle(fontSize: 38)),
    Text("Item 5", style: TextStyle(fontSize: 38)),
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.3, 1],
                  colors: [Colors.black, const Color(0xFF222359)])),
          child: pageOptions[selectedPage],
        ),
        bottomNavigationBar: bottomNavBar());
  }

  Widget earth() {
    return Object3D(
        size: const Size(40.0, 40.0), path: 'assets/earth.obj', asset: true);
  }

  Widget bottomNavBar() {
    return CupertinoTabBar(
      backgroundColor: Colors.black,
      activeColor: Colors.white,
      currentIndex: selectedPage,
      onTap: (int index) {
        setState(() {
          selectedPage = index;
        });
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home), title: Text('Group')),
        BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.improve), title: Text('Improve')),
        BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.logo), title: Text('Impact')),
        BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.insights), title: Text('Insights')),
        BottomNavigationBarItem(
            icon: Icon(MyFlutterApp.user), title: Text('Profile')),
      ],
    );
  }
}
