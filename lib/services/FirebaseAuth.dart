import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';

class FirebaseAuthservice {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final year = DateTime.now().year.toString();
  final month = DateTime.now().month.toString();
  final Widgets _widgets = Widgets();

  Future<String> firebaseSignup(
      {String email, String password, String username, String gender}) async {
    final String date = month + year;
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _db.collection("users").doc(_auth.currentUser.uid).set({
        "username": username,
        "monthlylimits": {"$date": 0.0},
        "theme": "light",
        "gender": gender,
        "months": [date],
        "currentMonth": DateTime.now().month.toString(),
      });
      return "1";
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> firebaseLogin({String email, String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "1";
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> signOut() async {
    try {
      await _auth.signOut();
      Get.back();
      return "1";
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> deleteAccount() async {
    try {
      await _auth.currentUser.delete();
      Get.back();
      return "1";
    } catch (error) {
      print(error);
      return error.toString();
    }
  }

  Future forgotPassword({@required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _widgets.successToste(
          message: "Email password-reset link is send to your Email");
    } catch (e) {
      String response = e.toString();
      response = e.toString().substring(response.indexOf("]") + 2);
      _widgets.warningToste(message: response);
    }
  }
}
