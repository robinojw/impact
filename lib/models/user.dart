import 'package:meta/meta.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String username;
  final String name;
  final String vehicle;
  final String fuel;
  final int engineSize;
  final int vehicleMpg;
  final String energy;
  final String electricity;
  final int electric;
  final int heating;
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

  // Map<String, dynamic> toJson() => {
  //       'username': username,
  //       'name': name,
  //       'vehicle': vehicle,
  //       'fuel': fuel,
  //       'engineSize': engineSize,
  //       'vehicleMpg': vehicleMpg,
  //       'energy': energy,
  //       'electricity': electricity,
  //       'electric': electric,
  //       'heating': heating,
  //       'commute': commute,
  //       'emissions': emissions,
  //       'city': city,
  //     };

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
}

class Emission {
  final String emissionIcon;
  final String emissionName;
  final String emissionType;
  final int ghGas;

  Emission(
      {this.emissionIcon, this.emissionName, this.emissionType, this.ghGas});

  factory Emission.fromJson(Map<String, dynamic> json) => Emission(
        emissionIcon: json["emissonIcon"],
        emissionName: json["emissionName"],
        emissionType: json["emissionType"],
        ghGas: json["ghGas"],
      );

  Map<String, dynamic> toJson() {
    return {
      'emissionIcon': emissionIcon,
      'emissionName': emissionName,
      'emissionType': emissionType,
      'ghGas': ghGas,
    };
  }
}
