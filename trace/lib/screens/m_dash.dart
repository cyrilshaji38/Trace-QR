import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Trace/screens/signup.dart';
import '../models/database.dart';
import 'signin.dart';
import 'package:Trace/screens/signin.dart';
import '../main.dart';

class MerchantDash extends StatefulWidget {

  final String documentId;
  MerchantDash(this.documentId);

  @override
  _MerchantDashState createState() => _MerchantDashState();
}

class _MerchantDashState extends State<MerchantDash> {

  void logout(){
    {Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));}
  }

  void clickQR() {
    if(profile != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CreateQR()));
    }
    else {
      Fluttertoast.showToast(
          msg: "Add profile picture first!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Scaffold(
              appBar: AppBar(
                  title: Text("Trace"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: this.logout,
                      child: Row(
                          children: <Widget>[
                            Text('Logout '),
                            Icon(Icons.logout)
                          ]
                      ),
                      style: TextButton.styleFrom(primary: Colors.white),
                    )
                  ]
              ),
              body:  Align(
                  alignment: Alignment.topLeft,
                  child:
                  ListView(
                      children: <Widget>[
                        Text("${data['Name']}", textScaleFactor: 2, textAlign: TextAlign.center),
                        GestureDetector(
                            child: CircleAvatar(
                                radius: 55, backgroundColor: Color(0xffFDCF09), child: profile != null ?
                            (ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.file(profile, width: 100, height: 100, fit: BoxFit.fitHeight,),))
                                :
                            (
                                Container(decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(50)), width: 100, height: 100,
                                  child: Icon(Icons.camera_alt, color: Colors.grey[800],),)
                            )
                            )
                        ),
                        Text("\nemail: ${data['Email']} \nMobile No: ${data['Mobile No']} \nPin Code: ${data['Pincode']}", textScaleFactor: 1.5),
                        Text("\nShow QR Code:", textScaleFactor: 1.5),
                        IconButton(icon: Icon(Icons.qr_code, size: 30), onPressed: this.clickQR, alignment: Alignment.centerLeft),
                      ]
                  )
              )
          );
        }

        return Scaffold(
            body: Center(child:
            CircularProgressIndicator(),
            )
        );
      },
    );
  }
}