import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DatabaseHelper extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final month = DateTime.now().month.toString();
  final year = DateTime.now().year.toString();

  DocumentReference userStream({String date}) {
    DocumentReference stream =
        _db.collection("users").doc(_auth.currentUser.uid);
    return stream;
  }

  DocumentReference categoryFieldsStream({@required String categoryName}) {
    final date = month + year;
    DocumentReference stream = _db
        .collection("users")
        .doc(_auth.currentUser.uid)
        .collection(date)
        .doc(categoryName);

    return stream;
  }

  CollectionReference categories({@required String date}) {
   
    CollectionReference stream =
        _db.collection("users").doc(_auth.currentUser.uid).collection(date);
    return stream;
  }
}
