import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  User({this.uid});
}

class UserData {
  final String username;
  final String name;
  final String vehicle;
  final String fuel;
  final double engineSize;
  final int vehicleMpg;
  final String energy;
  final String electricity;
  final double electric;
  final double heating;
  final String commute;
  final List<Emission> emissions;
  final String city;

  UserData({
    this.username,
    this.name,
    this.vehicle,
    this.fuel,
    this.engineSize,
    this.vehicleMpg,
    this.energy,
    this.electricity,
    this.electric,
    this.heating,
    this.commute,
    this.emissions,
    this.city,
  });

  Map<String, dynamic> toJson() {
    List<Map> emissions = this.emissions != null
        ? this.emissions.map((i) => i.toJson()).toList()
        : null;
    return {
      'username': username,
      'name': name,
      'vehicle': vehicle,
      'fuel': fuel,
      'engineSize': engineSize,
      'vehicleMpg': vehicleMpg,
      'energy': energy,
      'electricity': electricity,
      'electric': electric,
      'heating': heating,
      'commute': commute,
      'emissions': emissions,
      'city': city,
    };
  }

  UserData.fromSnapshot(DocumentSnapshot snapshot)
      : username = snapshot.data['username'],
        name = snapshot.data['name'],
        vehicle = snapshot.data['vehicle'],
        fuel = snapshot.data['fuel'],
        engineSize = snapshot.data['engineSize'],
        vehicleMpg = snapshot.data['vehicleMpg'],
        energy = snapshot.data['energy'],
        electricity = snapshot.data['electricity'],
        electric = snapshot.data['electric'],
        heating = snapshot.data['heating'],
        commute = snapshot.data['commute'],
        emissions = (snapshot.data['emissions'] as List)
            .map((i) => Emission.fromJson(i))
            .toList(),
        city = snapshot.data['city'];
}

class Emission {
  DateTime time;
  final String emissionIcon;
  final String emissionName;
  final String emissionType;
  final int ghGas;

  Emission(
      {this.time,
      this.emissionIcon,
      this.emissionName,
      this.emissionType,
      this.ghGas});

  factory Emission.fromJson(Map<String, dynamic> json) => Emission(
        time: (json['time'] as Timestamp).toDate(),
        emissionIcon: json["emissionIcon"],
        emissionName: json["emissionName"],
        emissionType: json["emissionType"],
        ghGas: json["ghGas"],
      );

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'emissionIcon': emissionIcon,
      'emissionName': emissionName,
      'emissionType': emissionType,
      'ghGas': ghGas,
    };
  }
}
