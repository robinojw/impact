import 'package:impact/screens/authenticate/register.dart';
import 'package:impact/screens/home/home.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/screens/shared/routing_constants.dart';

import 'package:flutter/material.dart';
import 'package:impact/screens/authenticate/authenticate.dart';
import 'package:impact/screens/welcome/energy_info.dart';
import 'package:impact/screens/welcome/get_started.dart';
import 'package:impact/screens/welcome/personal_info.dart';
import 'package:impact/screens/welcome/vechicle-info.dart';
import 'package:impact/screens/wrapper.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case wrapper:
      return MaterialPageRoute(builder: (context) => Wrapper());
    case auth:
      return MaterialPageRoute(builder: (context) => Authenticate());
    case register:
      return MaterialPageRoute(builder: (context) => Register());
    case start:
      return MaterialPageRoute(builder: (context) => GetStarted());
    case personal:
      return MaterialPageRoute(builder: (context) => PersonalInfo());
    case vehicle:
      return MaterialPageRoute(builder: (context) => VehicleInfo());
    case energy:
      return MaterialPageRoute(builder: (context) => EnergyInfo());
    case home:
      return MaterialPageRoute(builder: (context) => Home());
    case loading:
      return MaterialPageRoute(builder: (context) => Loading());
    default:
  }
}
