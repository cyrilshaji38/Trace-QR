import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser(name1, email1, mobile1, pincode1, acctype1, vaccine1, uid1, imageUrl1) async{
    return users.doc(uid1).set({
      'Name': name1,
      'Email': email1,
      'Mobile No': mobile1,
      'Pincode': pincode1,
      'Account Type': acctype1,
      'Vaccines Taken': vaccine1,
      'uid': uid1,
      'Profile Picture': imageUrl1
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }