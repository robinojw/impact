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
      await DatabaseService().updateItems(
          'https://discerningcyclist.com/wp-content/uploads/2020/03/How-Does-LARQ-Work-1024x820.jpg',
          'LARQ Smart Water Bottle',
          'The Larq water bottle is a state-of-the-art bottle capable of cleaning itself and purifying the water that\'s inside it. It utilizes environmentally-friendly UV-C technology to purify up to 99.9999% of bacteria and 99.99% of viruses when it\'s set to its highest mode',
          129,
          50);
      await DatabaseService().updateItems(
          'https://freitag.rokka.io/page-width/a454fd58b0e6e2093f23781fbc687bdb8b40aa11/000002184097-7-0-uz.jpg',
          'Freitag Messenger',
          'The medium-size, multifunctional FREITAG back-to-the-roots messenger bag: rugged, comfortable and the perfect multitasker.',
          250,
          600);
      await DatabaseService().updateItems(
          'https://www.greenqueen.com.hk/wp-content/uploads/2019/08/Lush-Cork-Packaging.jpg',
          'Lush Shampoo Bar',
          'Mint and spearmint are well known for their antiseptic and analgesic properties, stimulating and soothing your scalp to promote healthy hair growth. Herbal thyme, sandalwood and tarragon are antimicrobial - helping to balance your scalp.',
          8,
          70);
      await DatabaseService().updateItems(
          'https://cdn.blessthisstuff.com/imagens/stuff/sense-energy-monitor-2.jpg',
          'Sense Smart Energy Meter',
          'The Sense Home Energy Monitor tracks your home\'s energy use in real time to help you save, see what\'s happening in your home, and avoid disaster.',
          200,
          6000);
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
