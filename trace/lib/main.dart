import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

String name = "Cyril Shaji", email, mobile = "9568394830", pincode = "680688", password, password1,qrdata;
int acctype=1, vaccine=0;  // acctype (1--> customer  2--> merchant)
File profile;



final _picker = ImagePicker();
_picFromGallery() async {
  PickedFile image = await  _picker.getImage(
      source: ImageSource.gallery, imageQuality: 50
  );
    profile = File(image.path);
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
  TextEditingController controller = new TextEditingController();

  void clickdash() {
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
              TextField(decoration: InputDecoration(labelText: "email")),
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
      // print(name+email+mobile+pincode+password+"$acctype $vaccine");
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


  void createacc(){
    //first of all save all that input data into variables and then into the firebase database
    if(acctype==1)
      Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerDash()));
    else if(acctype==2)
      Navigator.push(context, MaterialPageRoute(builder: (context) => MerchantDash()));
  }
  void pwdmismatch(){
    Fluttertoast.showToast(
        msg: "Passwords do not match!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
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
    return
      Scaffold(
          appBar: AppBar(title: Text("Trace")),
          body:
          ListView(
              children: <Widget>
              [
                Text("SignUp", textScaleFactor: 2, textAlign: TextAlign.center),
                TextField(decoration: InputDecoration(labelText: "Name"), onChanged: (value) => name = value),
                TextField(decoration: InputDecoration(labelText: "Email"), onChanged: (value) => email = value),
                TextField(decoration: InputDecoration(labelText: "Mobile No"), onChanged: (value) => mobile = value),
                TextField(decoration: InputDecoration(labelText: "Pin Code"), onChanged: (value) => pincode = value),
                TextField(decoration: InputDecoration(labelText: "Create Password"), onChanged: (value) => password = value),
                TextField(decoration: InputDecoration(labelText: "Confirm Password"), onChanged: (value) => password1 = value),
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
                    onPressed: password1==password? this.createacc: this.pwdmismatch,
                    child: Text("SignUp"),
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.teal,
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                          )
                    )
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
                    data: "$mobile",
                    errorCorrectLevel: QrErrorCorrectLevel.M,
                    roundEdges: true)
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => ScanQR()));
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(title: Text("Trace")),
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
                      Text("\nemail: " /*+ email*/ + "\nMobile No:"/* + mobile*/ + "\nPin Code:"/* + pincode*/ + "\nVaccine Status:", textScaleFactor: 1.5),
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

class MerchantDash extends StatefulWidget {
  const MerchantDash({Key key}) : super(key: key);

  @override
  _MerchantDashState createState() => _MerchantDashState();
}


class _MerchantDashState extends State<MerchantDash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Trace")),
        //backgroundColor: Colors.black,
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