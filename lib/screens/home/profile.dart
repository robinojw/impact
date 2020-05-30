import 'package:flutter/material.dart';
import 'package:impact/models/user.dart';
import 'package:impact/screens/home/insights.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/screens/shared/routing_constants.dart';
import 'package:impact/services/auth.dart';
import 'package:impact/services/database.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Icon vehicleIcon;
  Insights insights;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return FutureBuilder<UserData>(
        future: DatabaseService(uid: user.uid).getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Column(children: <Widget>[
                    SizedBox(height: 20),
                    profileImg(userData),
                    SizedBox(height: 40),
                    monthlyStats(userData),
                    SizedBox(height: 30),
                    personalVehicle(
                        userData,
                        'Personal Vehicle',
                        Icon(Icons.directions_car,
                            color: Colors.white, size: 28)),
                    SizedBox(height: 10),
                    commuteTravel(userData),
                    SizedBox(height: 10),
                    accountInfo(userData),
                  ]),
                ],
              ),
            );
          } else {
            return Container(height: 0);
          }
        });
  }

  Widget profileImg(UserData userData) {
    return Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        IconButton(
            icon: Icon(Icons.exit_to_app),
            iconSize: 24,
            color: Colors.white,
            onPressed: () async {
              await AuthService().signOut();
              Navigator.pushNamed(context, start);
            })
      ]),
      new Container(
          width: 120.0,
          height: 120.0,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new AssetImage('assets/default-profile.png')))),
      SizedBox(height: 15),
      Text(userData.name,
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    ]);
  }

  Widget monthlyStats(UserData userData) {
    var emissions = userData.emissions;
    int pollution = 0;

    for (final data in emissions) {
      pollution += data.ghGas;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: <Widget>[
            Icon(Icons.flash_on, color: Colors.white),
            SizedBox(height: 5),
            Text((userData.electric.toInt()).toString() + " Kwh",
                style: TextStyle(color: Colors.white, fontSize: 14))
          ],
        ),
        Column(
          children: <Widget>[
            Icon(Icons.whatshot, color: Colors.white),
            SizedBox(height: 5),
            Text((userData.heating.toInt()).toString() + " Kwh",
                style: TextStyle(color: Colors.white, fontSize: 14))
          ],
        ),
        Column(
          children: <Widget>[
            Icon(Icons.filter_drama, color: Colors.white),
            SizedBox(height: 5),
            Text((pollution / 1000).toStringAsFixed(1) + " KG",
                style: TextStyle(color: Colors.white, fontSize: 14))
          ],
        )
      ],
    );
  }

  Widget personalVehicle(UserData userData, String title, Icon icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title,
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFF252740),
          ),
          padding: EdgeInsets.only(top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              getIcon(userData.vehicle),
              Text(userData.fuel, style: TextStyle(color: Colors.white)),
              Text(userData.vehicleMpg.toString() + " Mpg",
                  style: TextStyle(color: Colors.white)),
              Text(userData.engineSize.toString() + "L",
                  style: TextStyle(color: Colors.white)),
              Text('155 Miles', style: TextStyle(color: Colors.white))
            ],
          ),
        )
      ],
    );
  }

  Widget commuteTravel(UserData userData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Commute',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFF252740),
          ),
          padding: EdgeInsets.only(top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              getIcon(userData.commute),
              Text('Electric', style: TextStyle(color: Colors.white)),
              Text('N/A', style: TextStyle(color: Colors.white)),
              Text('N/A', style: TextStyle(color: Colors.white)),
              Text('155 Miles', style: TextStyle(color: Colors.white))
            ],
          ),
        )
      ],
    );
  }

  Widget accountInfo(UserData userData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Account Information',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0xFF252740),
          ),
          padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
          child: Column(
            children: <Widget>[
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Username', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 15),
                  Text('@' + userData.username,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 7),
              Container(
                  height: 1.5, width: 400, color: const Color(0xFF384869)),
              SizedBox(height: 7),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Email', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 47),
                  Text('robin@impactapp.uk',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              SizedBox(height: 7),
              Container(
                  height: 1.5, width: 400, color: const Color(0xFF384869)),
              SizedBox(height: 7),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Location', style: TextStyle(color: Colors.white)),
                  SizedBox(width: 26),
                  Text(userData.city, style: TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Icon getIcon(String icon) {
    switch (icon) {
      case 'Bicycle':
        return Icon(
          Icons.directions_bike,
          color: Colors.white,
          size: 29,
        );
      case 'Underground':
        return Icon(
          Icons.directions_subway,
          color: Colors.white,
          size: 29,
        );
      case 'Bus':
        return Icon(
          Icons.directions_bus,
          color: Colors.white,
          size: 29,
        );
      case 'Train':
        return Icon(
          Icons.train,
          color: Colors.white,
          size: 29,
        );
      case 'Car':
        return Icon(
          Icons.directions_car,
          color: Colors.white,
          size: 29,
        );
      case 'directions_boat':
        return Icon(
          Icons.directions_boat,
          color: Colors.white,
          size: 29,
        );
      case 'Motorbike':
        return Icon(
          Icons.motorcycle,
          color: Colors.white,
          size: 29,
        );
      case 'tram':
        return Icon(
          Icons.tram,
          color: Colors.white,
          size: 29,
        );
      case 'Airplane':
        return Icon(
          Icons.flight,
          color: Colors.white,
          size: 29,
        );
      case 'battery_full':
        return Icon(
          Icons.battery_full,
          color: Colors.white,
          size: 29,
        );
      case 'local_cafe':
        return Icon(
          Icons.local_cafe,
          color: Colors.white,
          size: 29,
        );
      case 'web_asset':
        return Icon(
          Icons.web_asset,
          color: Colors.white,
          size: 29,
        );
      case 'archive':
        return Icon(
          Icons.archive,
          color: Colors.white,
          size: 29,
        );
      case 'layers':
        return Icon(
          Icons.layers,
          color: Colors.white,
          size: 29,
        );
      case 'shopping_basket':
        return Icon(
          Icons.shopping_basket,
          color: Colors.white,
          size: 29,
        );
        break;
      default:
        return Icon(
          Icons.filter_drama,
          color: Colors.white,
          size: 29,
        );
    }
  }
}
