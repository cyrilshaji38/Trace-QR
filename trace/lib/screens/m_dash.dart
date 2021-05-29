import 'dart:ui';
import 'package:Trace/screens/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:Trace/main.dart';
import '../models/database.dart';
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => QR()));
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
          imageUrlC = "${data['Profile Picture']}";
          return new WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                  appBar: AppBar(title: Text("Trace"), actions: <Widget>[
                    TextButton(
                      onPressed: this.logout,
                      child: Row(children: <Widget>[
                        Text('Logout '),
                        Icon(Icons.logout)
                      ]),
                      style: TextButton.styleFrom(primary: Colors.white),
                    )
                  ]),
                  body: Align(
                      alignment: Alignment.topLeft,
                      child: ListView(children: <Widget>[
                        Text("${data['Name']}",
                            textScaleFactor: 3, textAlign: TextAlign.center),
                        GestureDetector(
                            child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Color(0xffFDCF09),
                                child: imageUrlC != null
                                    ? (ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          "${data['Profile Picture']}",
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ))
                                    : (Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        width: 100,
                                        height: 100,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      )))),
                        Text(
                            "\nemail: ${data['Email']} \nMobile No: ${data['Mobile No']} \nPin Code: ${data['Pincode']}",
                            textScaleFactor: 1.5),
                        Text("\nShow QR Code:", textScaleFactor: 1.5),
                        IconButton(
                            icon: Icon(Icons.qr_code, size: 30),
                            onPressed: this.clickQR,
                            alignment: Alignment.centerLeft),
                        Text("\nCustomer List", textScaleFactor: 2, textAlign: TextAlign.center),
                        Text("${data['Customer List']}".replaceAll('[', '').replaceAll("]", ""),textScaleFactor: 1.5),
                      ]))));
        }

        return Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      },
    );
  }
}

class QR extends StatefulWidget {
  @override
  _QRState createState() => _QRState();
}

class _QRState extends State<QR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
            child: PrettyQr(
                image: AssetImage("assets/images/Trace.png"),
                typeNumber: 3,
                size: 300,
                data: "$uidC",
                errorCorrectLevel: QrErrorCorrectLevel.M,
                roundEdges: true)
        )
    );
  }
}