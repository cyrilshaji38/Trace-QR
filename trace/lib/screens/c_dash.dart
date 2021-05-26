import 'dart:ui';
import 'package:Trace/screens/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/database.dart';
import '../main.dart';

class CustomerDash extends StatefulWidget {
  final String documentId;

  CustomerDash(this.documentId);

  @override
  _CustomerDashState createState() => _CustomerDashState();
}

class _CustomerDashState extends State<CustomerDash> {
  void clickQR() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScanQR()));
  }

  void places() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlacesVisited()));
  }

  void logout() {
    {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Signin()));
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
                            "\nemail: ${data['Email']} \nMobile No: ${data['Mobile No']} \nPin Code: ${data['Pincode']} \nVaccine Doses Taken: ${data['Vaccines Taken']}",
                            textScaleFactor: 1.5),
                        Text("\nScan QR Code: ", textScaleFactor: 1.5),
                        IconButton(
                            icon: Icon(Icons.camera_alt_outlined, size: 40),
                            onPressed: this.clickQR,
                            alignment: Alignment.centerLeft),
                        Text("\n\n"),
                        MaterialButton(
                          onPressed: () {},
                          child: ElevatedButton(
                              onPressed: this.places,
                              child: Text("Places Visited")),
                        )
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

class ScanQR extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text('Data: ${result.code}')
                  else
                    Text('Scan a code'),
                  Container(
                    margin: EdgeInsets.all(8),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlacesVisited()));
                          setState(() {});
                        },
                        child: FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return Text('Scan Complete');
                          },
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        qrdataC = "${result.code}";
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class PlacesVisited extends StatefulWidget {
  const PlacesVisited({Key key}) : super(key: key);

  @override
  _PlacesVisitedState createState() => _PlacesVisitedState();
}

class _PlacesVisitedState extends State<PlacesVisited> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Trace")),
        body: ListView(
          children: <Widget>[
            Text("\n"),
            Text("Places Visited",
                textAlign: TextAlign.center, textScaleFactor: 2),
            Text("\n$qrdataC")
          ],
        ));
  }
}
