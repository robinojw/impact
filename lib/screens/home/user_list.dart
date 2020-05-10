import 'package:flutter/material.dart';
import 'package:impact/models/impactUser.dart';
import 'package:provider/provider.dart';
import 'package:impact/screens/home/user_tile.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<ImpactUser>>(context) ?? [];
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

    return ListView.builder(
        shrinkWrap: true,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return UserTile(user: users[index]);
        });
  }
}
