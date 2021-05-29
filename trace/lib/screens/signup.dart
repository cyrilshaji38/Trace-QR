import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Trace/models/database.dart';
import '../main.dart';
import 'c_dash.dart';
import 'm_dash.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _storage = FirebaseStorage.instance;
final _picker = ImagePicker();
_picFromGallery() async {

  PickedFile image = await  _picker.getImage(
      source: ImageSource.gallery, imageQuality: 50
  );
  profile = File(image.path);
  var snapshot = await _storage.ref().child('Trace/Profile Picture/$email').putFile(profile);
  var downloadUrl = await snapshot.ref.getDownloadURL();
    imageUrl = downloadUrl;
}


void _showPicker(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _picFromGallery();
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
        );
      }
  );
}


class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final auth = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    acctype = 0;
  }

  setacctype(int val){
    setState(() {
      acctype = val;
    });
  }

  bool dose1 = false, dose2 = false;
  setvaccine1(bool value){
    setState(() {
      dose1 = value;
      dose1?vaccine=1:vaccine=0;
    });
  }
  setvaccine2(bool value){
    setState(() {
      dose2 = value;
      // ignore: unnecessary_statements
      dose2?vaccine=2:(dose1?vaccine=1:vaccine=0);
    });
  }

  // void pwdcheck(){
  //   if(password1==password)
  //     this.createacc();
  //   else
  //     this.pwdmismatch();
  // }

  void createacc(){
    String uid = auth.currentUser.uid;
    addUser(name, email, mobile, pincode, acctype, vaccine, uid, imageUrl);

    if(acctype==1)
      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDash(uid,uidM)));
    else if(acctype==2)
      Navigator.push(context, MaterialPageRoute(builder: (context) => MerchantDash(uid)));

  }

  void valuecheck(){
      Fluttertoast.showToast(
          msg: "Select an Account Type!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  // void pwdmismatch(){
  //   Fluttertoast.showToast(
  //       msg: "Passwords do not match!",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0
  //   );
  // }

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
    return
      Scaffold(
          appBar: AppBar(title: Text("Trace")),
          body:
          ListView(
              children: <Widget>
              [
                Text("SignUp", textScaleFactor: 2, textAlign: TextAlign.center),
                TextField(keyboardType: TextInputType.name, decoration: InputDecoration(labelText: "Name"), onChanged: (value) => name = value),
                TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: "Email"), onChanged: (value) => email = value),
                TextField(keyboardType: TextInputType.phone ,decoration: InputDecoration(labelText: "Mobile No"), onChanged: (value) => mobile = value),
                TextField(decoration: InputDecoration(labelText: "Pin Code"), onChanged: (value) => pincode = value),
                TextField(obscureText: true, decoration: InputDecoration(labelText: "Create Password"), onChanged: (value) => password = value),
                // TextField(obscureText: true, decoration: InputDecoration(labelText: "Confirm Password"), onChanged: (value) => password1 = value),
                Text("\n"),
                Row(
                    children: <Widget>
                    [
                      Text("Upload Profile Picture: ", textScaleFactor: 1.5),
                      GestureDetector(
                          onTap: () {_showPicker(context);},
                          child: CircleAvatar(
                              radius: 55, backgroundColor: Color(0xffFDCF09), child: profile != null ?
                          (ClipRRect(borderRadius: BorderRadius.circular(50), child: Image.file(profile, width: 100, height: 100, fit: BoxFit.fitHeight,),))
                              :
                          (
                              Container(decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(50)), width: 100, height: 100,
                                child: Icon(Icons.camera_alt, color: Colors.grey[800],),)
                          )
                          )
                      )
                    ]
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>
                    [
                      Column(
                          children: <Widget>
                          [
                            Text("\nCustomer", textScaleFactor: 1.5),
                            Radio(value: 1, groupValue: acctype, onChanged: (val){setacctype(val);}),
                            (acctype==1)? Text("Vaccinations \nTaken: "): Text(" "),
                            Row(
                                children: <Widget>
                                [
                                  (acctype==1)? Checkbox(value: dose1, onChanged: (val){setvaccine1(val);}): Text(" "),
                                  (acctype==1)?Text("Dose 1"): Text(" "),
                                  (acctype==1)? Checkbox(value: dose2, onChanged: (val){setvaccine2(val);}): Text(" "),
                                  (acctype==1)?Text("Dose 2"): Text(" "),
                                ]
                            )

                          ]
                      ),
                      Column(
                          children: <Widget>
                          [
                            Text("\n\n\nMerchant", textScaleFactor: 1.5),
                            Radio(value: 2, groupValue: acctype, onChanged: (val){setacctype(val);}),
                            (acctype==2)? Text("Generate \nQR Code:"): Text(" "),
                            (acctype==2)? IconButton(icon: Icon(Icons.qr_code, size: 30), onPressed: this.clickQR): Text(" "),
                          ]
                      )
                    ]
                ),
                Text("\n"),
                TextButton(
                    child: Text("SignUp"),
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.teal,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        )
                    ),
                    onPressed: () async{
                      if(acctype==0)
                        valuecheck();
                      else
                        try {
                          await auth.createUserWithEmailAndPassword(email: email, password: password);
                          this.createacc();
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                            Fluttertoast.showToast(
                                msg: "The password provided is too weak.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                            Fluttertoast.showToast(
                                msg: "The account already exists for that email.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                    }
                ),
                Text("\n\n\n")
              ]
          )
      );
  }
}


class CreateQR extends StatefulWidget {
  @override
  _CreateQRState createState() => _CreateQRState();
}

class _CreateQRState extends State<CreateQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Center(
            child: PrettyQr(
                image: FileImage(profile),
                typeNumber: 3,
                size: 300,
                data: "$uidC",
                errorCorrectLevel: QrErrorCorrectLevel.M,
                roundEdges: true)
        )
    );
  }
}