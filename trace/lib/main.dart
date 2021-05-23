import 'package:flutter/material.dart';
import 'dart:io';
import 'signin.dart';

String name = "Cyril Shaji", email, mobile = "9568394830", pincode = "680688", password, password1,qrdata;
int acctype=1, vaccine=0;  // acctype (1--> customer  2--> merchant)
File profile;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trace',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Signin(),
    );
  }
}










