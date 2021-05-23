import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'main.dart';
import 'signin.dart';


class CustomerDash extends StatefulWidget {
  const CustomerDash({Key key}) : super(key: key);

  @override
  _CustomerDashState createState() => _CustomerDashState();
}

class _CustomerDashState extends State<CustomerDash> {

  void clickQR() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScanQR()));
  }

  void logout(){
    {Navigator.push(context, MaterialPageRoute(builder: (context) => Signin()));}
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
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
                    Text("Customer Name", textScaleFactor: 2, textAlign: TextAlign.center),
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
                    Text("\nemail: $email \nMobile No:"/* + mobile*/ + "\nPin Code:"/* + pincode*/ + "\nVaccine Status:", textScaleFactor: 1.5),
                    Text("\nScan QR Code: ", textScaleFactor: 1.5),
                    IconButton(icon: Icon(Icons.camera_alt_outlined ,size: 40), onPressed: this.clickQR,  alignment: Alignment.centerLeft),
                  ]
              )
          )
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
                    Text(
                        'Data: ${result.code}')
                  else
                    Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});

                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                return Text('Flash: ${snapshot.data}');
                              },
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return Text(
                                      'Camera facing ${describeEnum(snapshot.data)}');
                                } else {
                                  return Text('loading');
                                }
                              },
                            )),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                            // print(qrdata);
                          },
                          child: Text('pause', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: Text('resume', style: TextStyle(fontSize: 20)),
                        ),
                      )
                    ],
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
        qrdata = "${result.code}";
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
