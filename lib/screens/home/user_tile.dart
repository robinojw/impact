import 'package:flutter/material.dart';
import 'package:impact/models/impactUser.dart';

class UserTile extends StatelessWidget {
  final ImpactUser user;
  UserTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.blue,
          ),
          title: Text(user.name),
          subtitle: Text(user.city),
        ),
      ),
    );
  }
}
