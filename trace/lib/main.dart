import 'package:flutter/material.dart';

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
        primarySwatch: Colors.green,
      ),
      home: SignIn(),
    );
  }
}

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Trace")),
        body: Column(children: <Widget>[
          Text("Signin"),
          TextField(decoration: InputDecoration(labelText: "email")),
          TextField(decoration: InputDecoration(labelText: "password")),
          IconButton(icon: Icon(Icons.arrow_forward,size: 40), onPressed: () => {})

        ])

    );
  }
}
