import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:impact/models/impactUser.dart';
import 'package:impact/models/item.dart';
import 'package:impact/models/user.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //Collection Reference
  final CollectionReference usersCollection =
      Firestore.instance.collection('users');

  final CollectionReference itemsCollection =
      Firestore.instance.collection('items');

  Future updateItems(
    String image,
    String title,
    String desc,
    int price,
    int savings,
  ) async {
    return await itemsCollection.document().setData({
      'image': image,
      'title': title,
      'desc': desc,
      'price': price,
      'savings': savings,
    });
  }

  Future updateUserData(
    String username,
    String name,
    String vehicle,
    String fuel,
    double engineSize,
    int vehicleMpg,
    String energy,
    String electricity,
    double electric,
    double heating,
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

  Future<UserData> getUserData() async {
    DocumentSnapshot userDocument = await usersCollection.document(uid).get();
    if (userDocument.exists) {
      return UserData.fromSnapshot(userDocument);
    } else {
      return UserData();
    }
  }

  Future<List<Item>> getItems() async {
    QuerySnapshot items = await itemsCollection.getDocuments();
    if (items.documents.isNotEmpty) {
      return _itemDataFromSnapshot(items);
    } else {
      return List<Item>();
    }
  }

  @override
  Future<bool> checkUserDocumentExists() async {
    DocumentSnapshot userDocument = await usersCollection.document(uid).get();
    return userDocument.exists;
  }

  //emissions from snapshot
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

  //Item data from snapshot
  List<Item> _itemDataFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Item(
        image: doc.data['image'] ?? '',
        title: doc.data['title'] ?? '',
        desc: doc.data['desc'] ?? '',
        price: doc.data['price'] ?? 0,
        savings: doc.data['savings'] ?? 0,
      );
    }).toList();
  }

  Stream<UserData> get userData {
    return usersCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData.fromSnapshot(snapshot);
  }

  Stream<List<Emission>> get emissionData {
    return usersCollection
        .document(uid)
        .snapshots()
        .map(_emissionListFromSnapshot);
  }

  Stream<List<Item>> get items {
    return itemsCollection.snapshots().map(_itemDataFromSnapshot);
  }
}
