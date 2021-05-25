import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:trace/c_dash.dart';
import 'package:trace/m_dash.dart';
import 'database.dart';
import 'signup.dart';
import 'main.dart';

String acctype3;
int acctype2;

class Signin extends StatefulWidget {
  const Signin({Key key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  String _email, _password;

  Future<void> login() async {
    uidC= auth.currentUser.uid;
      Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome(uidC)));
  }

  void clickup() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          appBar: AppBar(title: Text("Trace")),
          body: Column(
              children: <Widget>
              [
                Text("Login", textScaleFactor: 3),
                TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: "email"), onChanged: (value) {setState(() {_email = value.trim();});}),
                TextField(obscureText: true, decoration: InputDecoration(labelText: "password"), onChanged: (value) {setState(() {_password = value.trim();});}),
                IconButton(icon: Icon(Icons.arrow_forward, size: 50), onPressed: (){auth.signInWithEmailAndPassword(email: _email, password: _password).then((_){this.login();});}),
                Text("\n"),
                Row(
                    children: <Widget>
                    [
                      Text("Don't have an account? Signup", textScaleFactor: 1.5),
                      IconButton(icon: Icon(Icons.account_circle_outlined, size: 30), onPressed: this.clickup)
                    ]
                )
              ]
          )
      );
  }
}

class Welcome extends StatefulWidget {

  final String documentId;
  Welcome(this.documentId);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  void clickProfile() {
    if(acctype2 == 1)
      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDash(uidC)));
    else if(acctype2 == 2)
      Navigator.push(context, MaterialPageRoute(builder: (context) => MerchantDash(uidC)));
    else
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          acctype3 = "${data['Account Type']}";
          acctype2 = int.parse(acctype3);
          print(acctype2);
          return Scaffold(
            body: Column(
                children: <Widget>[
                  Text("\n\n\n\n\nWelcome to Trace! This app helps you to avoid having to write your details into a registry at every store you go to during this pandemic. Just scan the merchant's QR Code and you will have a digital record of the shop you visited. If you are a merchant you will have a digital copy of all the customers that have scanned your QR Code.", textScaleFactor: 2),
                  Text("\n"),
                  TextButton(
                      child: Text("My Account"),
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.teal,
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                          )
                      ),
                      onPressed: this.clickProfile
                  ),
                ]
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