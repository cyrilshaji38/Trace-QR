import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'screens/signin.dart';
import 'package:firebase_core/firebase_core.dart';

final auth = FirebaseAuth.instance;

String name, email, mobile, pincode, password, /*password1,*/ imageUrl, qrdata;
int acctype=0, vaccine=0, i; // acctype (1--> customer  2--> merchant)

List<dynamic> qrdataC = [], customerData = [];

File profile;

String uidC, imageUrlC, newQRdata, uidM;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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