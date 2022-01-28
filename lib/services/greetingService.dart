import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/services/database.dart';

class GreetingService {
  final DatabaseHelper streams = DatabaseHelper();
  final Widgets _widgets = Widgets();
  Future greeting() async {
    DocumentSnapshot user = await streams.userStream().get();
    String username = user.data()["username"] ?? "User";
    String greeting;
    int time = DateTime.now().hour;

    if (0 <= time && time <= 12) {
      greeting = "Good Morning $username";
    } else if (time > 12 && time < 18) {
      greeting = "Good Afternoon $username";
    } else if (time >= 18 && time < 24) {
      greeting = "Good evening $username";
    }
    Get.snackbar(
      "",
      "",
      duration: Duration(milliseconds: 3000),
      colorText: Colors.black,
      messageText:
          _widgets.text(val: greeting, color: Colors.black, fontsize: 16.0),
      titleText: _widgets.text(
        val: "Hey ,",
        fontsize: 18.0,
        color: Colors.black,
      ),
    );
  }
}
