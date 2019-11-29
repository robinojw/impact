import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_bloc/src/screens/login_screen.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String _email;
  String _password;
  String _username;

  final _formKey = new GlobalKey<FormState>();

  Future<void> signUp() async {
    final formState = _formKey.currentState;
    //Validate fields
    if (formState.validate()) {
      formState.save();
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } catch (e) {
        print(e.message);
      }
    }
    //Login to firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.3, 1],
              colors: [Colors.black, const Color(0xFF222359)])),
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(margin: EdgeInsets.only(top: 120)),
          welcomeMessage(),
          _showForm(),
        ],
      ),
    ));
  }

  Widget _showForm() {
    return new Container(
        child: Form(
            key: _formKey,
            child: new ListView(
              shrinkWrap: true,
              children: <Widget>[
                usernameField(),
                emailField(),
                passwordField(),
                Container(margin: EdgeInsets.only(top: 17.5)),
                createButton(),
              ],
            )));
  }

  Widget welcomeMessage() {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Create an',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.0)),
        Text('Account.',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.0))
      ],
    ));
  }

  Widget usernameField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: 'you123',
          labelText: 'Username:',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: new UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 1.0, style: BorderStyle.solid))),
      validator: (value) => value.isEmpty ? 'Username can\'t be empty' : null,
      onSaved: (value) => _username = value.trim(),
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: 'you@example.com',
          labelText: 'Email:',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: new UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 1.0, style: BorderStyle.solid))),
      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      onSaved: (value) => _email = value.trim(),
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      maxLines: 1,
      autofocus: false,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintText: 'Password',
          labelText: 'Password:',
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: new UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 1.0, style: BorderStyle.solid))),
      validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
      onSaved: (value) => _password = value.trim(),
    );
  }

  Widget createButton() {
    return ButtonTheme(
        minWidth: 600,
        height: 44,
        child: RaisedButton(
          child: Text(
            'Create Account',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.normal),
          ),
          color: Colors.white,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(5.0),
          ),
          onPressed: signUp,
        ));
  }
}
