import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    hintStyle: TextStyle(color: Colors.white, fontSize: 14),
    contentPadding: EdgeInsets.all(0));

const backgroundGradient = BoxDecoration(
    gradient: LinearGradient(
        colors: [const Color(0xFF091A51), const Color(0XFF000000)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.25, 1.5]));

final iconDecoration = BoxDecoration(
  color: const Color(0XFFe1e7f0),
  borderRadius: BorderRadius.circular(10),
);
