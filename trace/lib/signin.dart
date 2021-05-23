import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'signup.dart';
import 'c_dash.dart';


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
