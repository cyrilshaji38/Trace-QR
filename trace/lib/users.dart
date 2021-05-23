import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

Future<void> userSetup(String displayName) async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser.uid.toString();
  users.add({
    'Name': name,
    'Mobile No ': mobile,
    'Pin Code ': pincode,
    'Account Type ': acctype,
    'Vaccinations Taken ': vaccine,
    'uid': uid});
  return;
}
