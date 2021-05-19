import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

String name, email, mobile, pincode, password;
int acctype;  // 1--> customer  2--> merchant
Image profile, qr;

void main() {
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


class Signin extends StatefulWidget {
  const Signin({Key key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  // String email;
  TextEditingController controller = new TextEditingController();

  void clickdash() {
    email = controller.text;
    Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDash()));
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
              TextField(controller: this.controller, decoration: InputDecoration(labelText: "email")),
              TextField(decoration: InputDecoration(labelText: "password")),
              IconButton(icon: Icon(Icons.arrow_forward, size: 50), onPressed: this.clickdash),
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


class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

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

  void createacc(){
    //first of all save all that input data into variables and then into the firebase database
    if(acctype==1)
      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDash()));
    else if(acctype==2)
      Navigator.push(context, MaterialPageRoute(builder: (context) => MerchantDash()));
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
                TextField(decoration: InputDecoration(labelText: "Name")),
                TextField(decoration: InputDecoration(labelText: "Email")),
                TextField(decoration: InputDecoration(labelText: "Mobile No")),
                TextField(decoration: InputDecoration(labelText: "Pin Code")),
                Text("\n"),
                Row(
                    children: <Widget>
                    [
                      Text("Upload Profile Picture: ", textScaleFactor: 1.5),
                      IconButton(icon: Icon(Icons.upload_sharp, size: 30), onPressed: () => {})
                    ]
                ),
                Row(
                    children: <Widget>
                    [
                      Column(
                          children: <Widget>
                          [
                            Text("\nCustomer", textScaleFactor: 1.5),
                            Radio(value: 1, groupValue: acctype, onChanged: (val){setacctype(val);}),
                            (acctype==1)? Text(" Upload \n Vaccination \n Certififcates: "): Text(" "),
                            (acctype==1)? IconButton(icon: Icon(Icons.upload_sharp, size: 30), onPressed: () => {}): Text(" ")
                          ]
                      ),
                      Column(
                          children: <Widget>
                          [
                            Text("\t\t\tMerchant", textScaleFactor: 1.5),
                            Radio(value: 2, groupValue: acctype, onChanged: (val){setacctype(val);}),
                            (acctype==2)? Text("Generate \nQR Code:"): Text(" "),
                            (acctype==2)? IconButton(icon: Icon(Icons.qr_code, size: 30), onPressed: () => {}): Text(" ")
                          ]
                      )
                    ]
                ),
                TextField(decoration: InputDecoration(labelText: "Create Password")),
                TextField(decoration: InputDecoration(labelText: "Confirm Password")),
                TextButton(
                    onPressed: this.createacc,
                    child: Text("SignUp"),
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.teal,
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            // fontStyle: FontStyle.
                          )
                    )
                ),
                Text("\n\n\n")
              ]
          )
      );
  }
}



class CustomerDash extends StatefulWidget {
  const CustomerDash({Key key}) : super(key: key);

  @override
  _CustomerDashState createState() => _CustomerDashState();
}

class _CustomerDashState extends State<CustomerDash> {

  void clickQR() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => QRViewExample()));
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(title: Text("Trace")),
          body:  Align(
            alignment: Alignment.topLeft,
            child:
                Column(
                    children: <Widget>[
                      // Text(name, textScaleFactor: 2),
                      Text("email: " + email + "\nMobile No:"/* + mobile*/ + "\nPin Code:"/* + pincode*/ + "\nVaccine Status:", textScaleFactor: 1.5),
                      Text("\nScan QR Code: ", textScaleFactor: 1.5),
                      IconButton(icon: Icon(Icons.camera_alt_outlined ,size: 40), onPressed: this.clickQR,)
                    ]
                )
        )
      );
  }
}


class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
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
                        'Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}')
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
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class MerchantDash extends StatefulWidget {
  const MerchantDash({Key key}) : super(key: key);

  @override
  _MerchantDashState createState() => _MerchantDashState();
}

class _MerchantDashState extends State<MerchantDash> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(title: Text("Trace")),
        body: Text("LULU MALL", textScaleFactor: 2),
      );
  }
}