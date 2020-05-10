import 'package:flutter/material.dart';
import 'package:impact/screens/shared/constants.dart';
import 'package:impact/screens/shared/loading.dart';
import 'package:impact/screens/shared/routing_constants.dart';
import 'package:impact/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  //Text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            decoration: backgroundGradient,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: Text(
                        'Create an Account.',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
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
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Password:'),
                            validator: (val) => val.length < 6
                                ? 'Password must be at least 8 characters'
                                : null,
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 15),
                          ButtonTheme(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            minWidth: 400.0,
                            height: 45.0,
                            child: FlatButton(
                              child: Text("Create Account",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w400)),
                              color: Colors.white,
                              textColor: Colors.black,
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email, password);

                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'Please supply a valid email';
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 12.0),
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            textColor: Colors.white,
                            child: Text("Already have an account? Sign In"),
                            onPressed: () {
                              widget.toggleView();
                            },
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
