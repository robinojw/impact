import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impact/models/impactUser.dart';
import 'package:impact/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //Collection Reference
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  Future updateUserData(
    String username,
    String name,
    String vehicle,
    String fuel,
    int engineSize,
    int vehicleMpg,
    String energy,
    String electricity,
    int electric,
    int heating,
    String commute,
    String city,
  ) async {
    return await usersCollection.document(uid).setData({
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
      'city': city,
    });
  }

  //Users from snapshot
  List<ImpactUser> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return ImpactUser(
        username: doc.data['username'] ?? '',
        name: doc.data['name'] ?? '',
        vehicle: doc.data['vehicle'] ?? '',
        fuel: doc.data['fuel'] ?? '',
        engineSize: doc.data['engineSize'] ?? '',
        vehicleMpg: doc.data['vehicleMpg'] ?? 0,
        energy: doc.data['energy'] ?? '',
        electricity: doc.data['electricity'] ?? '',
        electric: doc.data['electric'] ?? '',
        heating: doc.data['heating'] ?? '',
        commute: doc.data['commute'] ?? '',
        city: doc.data['city'] ?? '',
      );
    }).toList();
  }

  //Get users stream
  Stream<List<ImpactUser>> get users {
    return usersCollection.snapshots().map(_userListFromSnapshot);
  }

  //User data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      username: snapshot.data['username'],
      name: snapshot.data['name'],
      vehicle: snapshot.data['vehicle'],
      fuel: snapshot.data['fuel'],
      engineSize: snapshot.data['engineSize'],
      vehicleMpg: snapshot.data['vehicleMpg'],
      energy: snapshot.data['energy'],
      electricity: snapshot.data['electricity'],
      electric: snapshot.data['electric'],
      heating: snapshot.data['heating'],
      commute: snapshot.data['commute'],
      city: snapshot.data['city'],
    );
  }

  //Get user doc stream
  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
