import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'signin.dart';

class MerchantDash extends StatefulWidget {
  const MerchantDash({Key key}) : super(key: key);

  @override
  _MerchantDashState createState() => _MerchantDashState();
}


class _MerchantDashState extends State<MerchantDash> {

  void logout(){
    {Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));}
  }

  @override
  Widget build(BuildContext context) {
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
        body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      //Icon(Icons.menu, color: Colors.white,size: 52.0,),
                      // Image.asset("assets/image.png",width: 52.0,)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "Welcome,  \nSelect an option",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Wrap(
                      spacing:20,
                      runSpacing: 20.0,
                      children: <Widget>[
                        SizedBox(
                          width:160.0,
                          height: 160.0,
                          child: Card(

                            color: Colors.teal,
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)
                            ),
                            child:Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      // Image.asset("assets/.png",width: 64.0,),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "QR Code",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),

                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                        SizedBox(
                          width:160.0,
                          height: 160.0,
                          child: Card(

                            color: Colors.teal,
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)
                            ),
                            child:Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      // Image.asset("assets/.png",width: 64.0,),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "Edit Details",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),

                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),
                        SizedBox(
                          width:160.0,
                          height: 160.0,
                          child: Card(

                            color: Colors.teal,
                            elevation: 2.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)
                            ),
                            child:Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      // Image.asset("assets/.png",width: 64.0,),
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "Log Summary",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),

                                    ],
                                  ),
                                )
                            ),
                          ),
                        ),



                      ],
                    ),
                  ),
                )
              ],
            )
        )
    );
  }
}