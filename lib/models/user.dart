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
    this.city,
  });
}

class Emission {
  final String emissionIcon;
  final String emissionName;
  final String emissionType;
  final int ghGas;

  Emission(
      {this.emissionIcon, this.emissionName, this.emissionType, this.ghGas});
}
