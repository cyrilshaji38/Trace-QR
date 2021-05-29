import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Trace/main.dart';

CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(name1, email1, mobile1, pincode1, acctype1, vaccine1, uidC1, imageUrl1) async{
    return users.doc(uidC1).set({
      'Name': name1,
      'Email': email1,
      'Mobile No': mobile1,
      'Pincode': pincode1,
      'Account Type': acctype1,
      'Vaccines Taken': vaccine1,
      'uid': uidC1,
      'Profile Picture': imageUrl1
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateC(qrdataC1) async{
    return users.doc(uidC).update({
      'QR Data': qrdataC1
    });
  }

  Future<void> updateM(customerData1, uidM1) async{
    return users.doc(uidM1).update({
      'Customer List': customerData1
    });
  }