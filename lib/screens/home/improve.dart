import 'package:flutter/material.dart';
import 'package:impact/models/item.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';

class Improve extends StatefulWidget {
  @override
  _ImproveState createState() => _ImproveState();
}

class _ImproveState extends State<Improve> {
  double listHeight = 0;
  int itemIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(children: <Widget>[
              SizedBox(height: 35),
              titleRow('Decrease your impact'),
              SizedBox(height: 15),
              article(),
              SizedBox(height: 20),
              titleRow('Low impact alternatives'),
              SizedBox(height: 15),
              Container(
                height: listHeight,
                child: StreamBuilder<List<Item>>(
                    stream: DatabaseService().items,
                    builder: (context, snapshot) {
                      List<Item> items = snapshot.data;
                      return Container(child: itemList(items));
                    }),
              ),
            ])));
  }

  Widget titleRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        Icon(Icons.help, color: Colors.grey, size: 18),
      ],
    );
  }

  Widget article() {
    return Container(
        width: 400,
        height: 180,
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/underground.png'), fit: BoxFit.cover),
            border: Border.all(width: 0),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Container(
            height: 800,
            padding: EdgeInsets.only(left: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Guide to London Transport',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 5),
                  Text('Lower the impact of your commute',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.normal)),
                  SizedBox(height: 10),
                ])));
  }

  Widget itemList(List<Item> items) {
    listHeight = 230 * items.length.toDouble() / 2;
    var widgetList = List<Widget>();

    for (var item in items) {
      widgetList.add(newItem(item));
    }
    return Wrap(spacing: 20.0, children: widgetList);
  }

  Widget newItem(Item item) {
    return new Container(
      width: 165,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 188,
                width: 165,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(item.image),
                      fit: BoxFit.cover,
                    ))),
            SizedBox(height: 5),
            Text(item.title,
                style: TextStyle(color: Colors.white, fontSize: 12)),
            SizedBox(height: 2),
            Text(
              "£" + item.price.toString(),
              style: TextStyle(color: const Color(0xFFBCC158), fontSize: 12),
            ),
            SizedBox(height: 10),
          ]),
    );
  }
}
