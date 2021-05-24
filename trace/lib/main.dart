// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'signin.dart';
import 'package:firebase_core/firebase_core.dart';

final auth = FirebaseAuth.instance;

String name, email, mobile, pincode, password, /*password1,*/ qrdata;
int acctype=1, vaccine=0;  // acctype (1--> customer  2--> merchant)
File profile;

// String c_email = auth.currentUser.email;
// void getUserData() async{
//   var firebaseUser = await auth.instance.currentUser();
//   firestoreInstance.collection("users").document(firebaseUser.uid).get().then((value){
//     print(value.data);
//   });
// }
// String c_name =


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










