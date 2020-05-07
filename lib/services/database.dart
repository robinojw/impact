import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impact/models/impactUser.dart';

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

  //Users from snapshot
  List<ImpactUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return ImpactUser(
        name: doc.data['name'] ?? '',
        energy: doc.data['energy'] ?? '',
        vehicle: doc.data['vehicle'] ?? '',
        vehicleMpg: doc.data['vehicleMpg'] ?? 0,
        commute: doc.data['commute'] ?? '',
        city: doc.data['city'] ?? '',
      );
    }).toList();
  }

  //Get users stream
  Stream<List<ImpactUser>> get users {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }
}
