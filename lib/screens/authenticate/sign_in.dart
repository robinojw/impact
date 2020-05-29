import "package:flutter/material.dart";
import 'package:impact/screens/authenticate/register.dart';
import 'package:impact/screens/shared/constants.dart';
import 'package:impact/screens/shared/routing_constants.dart';
import 'package:impact/services/auth.dart';
import 'package:impact/screens/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: backgroundGradient,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(height: 120),
                  Container(
                    width: 300,
                    child: Text(
                      'Welcome to Impact.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: 400,
                    height: 45,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      child: Text('Sign in with Apple',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal)),
                      color: Colors.white,
                      onPressed: () {
                        widget.toggleView();
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 160,
                          height: 45,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            textColor: Colors.white,
                            child: Text('Sign in with Google',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                            color: const Color(0xFF1451DB),
                            onPressed: () {
                              widget.toggleView();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          height: 45,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            textColor: Colors.white,
                            child: Text('Create Account',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)),
                            color: const Color(0xFF1451DB),
                            onPressed: () {
                              widget.toggleView();
                            },
                          ),
                        ),
                      ]),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          height: 1.0,
                          width: 155,
                          color: const Color(0XFF1C3779)),
                      Text('or',
                          style: TextStyle(color: const Color(0XFF1C3779))),
                      Container(
                          height: 1.0,
                          width: 155,
                          color: const Color(0XFF1C3779)),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Email:'),
                            validator: (val) => val.isEmpty
                                ? 'Enter a valid email address'
                                : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Password:'),
                            validator: (val) => val.length < 6
                                ? 'Password must be at least 6 characters'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 10),
                        ]),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  fontSize: 14, color: const Color(0XFF1451DB)),
                            )),
                        ButtonTheme(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          minWidth: 150.0,
                          height: 42.5,
                          child: FlatButton(
                            child: Text("Log In",
                                style: TextStyle(fontWeight: FontWeight.w400)),
                            color: const Color(0xFF1451DB),
                            textColor: Colors.white,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);

                                if (result == null) {
                                  setState(() =>
                                      error = 'This account doesn\'t exist');
                                  setState(() => loading = false);
                                } else {
                                  Navigator.pushNamed(context, home);
                                }
                              }
                            },
                          ),
                        ),
                      ]),
                  // SizedBox(height: 12.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            )));
  }
}
