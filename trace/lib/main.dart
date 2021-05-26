import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'screens/signin.dart';
import 'package:firebase_core/firebase_core.dart';

final auth = FirebaseAuth.instance;

String name, email, mobile, pincode, password, /*password1,*/ imageUrl, qrdataC = "No Places Visited!", qrdataM = "Name: $name, Pincode: $pincode";
int acctype=0, vaccine=0; // acctype (1--> customer  2--> merchant)
// List<String> qrdataC1 = [];
File profile;

String nameC, emailC, mobileC, pincodeC, uidC, imageUrlC;
int acctypeC, vaccineC;


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