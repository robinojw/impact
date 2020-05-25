import 'package:firebase_auth/firebase_auth.dart';
import 'package:impact/models/user.dart';
import 'package:impact/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      List<Emission> emissions = [
        Emission(
            emissionIcon: "Car",
            emissionName: "Car Journey",
            emissionType: "5.6 Miles",
            ghGas: 621),
        Emission(
            emissionIcon: "Car",
            emissionName: "Car Journey",
            emissionType: "5.6 Miles",
            ghGas: 621),
        Emission(
            emissionIcon: "Car",
            emissionName: "Car Journey",
            emissionType: "5.6 Miles",
            ghGas: 621),
        Emission(
            emissionIcon: "Car",
            emissionName: "Car Journey",
            emissionType: "5.6 Miles",
            ghGas: 621)
      ];
      await DatabaseService(uid: user.uid).updateUserData(
        '',
        '',
        'I don\'t have a vehicle',
        'No engine or motor',
        0,
        0,
        'Gas',
        'Grid',
        0,
        0,
        'I don\'t commute to work or school',
        emissions,
        '',
      );
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
