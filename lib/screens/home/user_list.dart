import 'package:flutter/material.dart';
import 'package:impact/models/impactUser.dart';
import 'package:provider/provider.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<ImpactUser>>(context);
    // print(users.documents);
    // print(users.length);
    users.forEach((user) {
      print(user.name);
      print(user.energy);
      print(user.vehicle);
      print(user.vehicleMpg);
      print(user.commute);
      print(user.city);
    });

    return Container();
  }
}
