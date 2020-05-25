import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impact/models/impactUser.dart';
import 'package:impact/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //Collection Reference
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  final CollectionReference emissionCollection =
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
    List<Emission> emissions,
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
      'emissions':
          emissions != null ? emissions.map((i) => i.toJson()).toList() : null,
      'city': city,
    });
  }

  //User data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    var emissionsList = snapshot.data['emissions'] as List;
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
      emissions: emissionsList.map((i) => Emission.fromJson(i)).toList(),
      city: snapshot.data['city'],
    );
  }

  //Users from snapshot
  List<Emission> _emissionListFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.data['emissions'].map((doc) {
      return Emission(
        emissionIcon: doc.data['emissionIcon'] ?? "",
        emissionName: doc.data['emissionName'] ?? "",
        emissionType: doc.data['emissionType'] ?? "",
        ghGas: doc.data['ghGas'] ?? "",
      );
    }).toList();
  }

  //Get user doc stream

  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<List<Emission>> get emissionData {
    return emissionCollection
        .document(uid)
        .snapshots()
        .map(_emissionListFromSnapshot);
  }

  // Stream<List<Emission>> get emissionData {
  //   return usersCollection.document(uid).snapshots().map(_userListFromSnapshot);
  // }

  // //Get users stream
  // Stream<List<Emission>> get emissions {
  //   return usersCollection.snapshots().map(_emissionListFromSnapshot);
  // }
}
