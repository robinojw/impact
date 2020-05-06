import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //Collection Reference
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  Future updateUserData(String name, String energy, String vehicle,
      int vehicleMpg, String commute, String city) async {
    return await usersCollection.document(uid).setData({
      'name': name,
      'energy': energy,
      'vehicle': vehicle,
      'vehicleMpg': vehicleMpg,
      'commute': commute,
      'city': city,
    });
  }
}
