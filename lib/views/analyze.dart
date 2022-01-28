//import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/constants/colors.dart';
import 'package:household_expences/models/FireDatabaseApi.dart';
import 'package:household_expences/services/database.dart';
import 'package:household_expences/views/analyzeMonth.dart';
import 'package:provider/provider.dart';

class Analyze extends StatelessWidget {
  //final FirebaseFirestore _db = FirebaseFirestore.instance;
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  final ConstantColors colors = ConstantColors();
  final Widgets _widgets = Widgets();
  final List weeks = ["s", "m", "t", "w", "t", "f", "s"];
  static List<String> monthsReference = [
    "January",
    "Febrary",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  final DatabaseHelper streams = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _widgets.text(
          val: "Analyze",
          color: colors.greyColor,
          fontsize: 18.0,
        ),
        backgroundColor: colors.blueColor,
        elevation: 0.0,
      ),
      body: Consumer<FireApi>(
          builder: (BuildContext context, FireApi api, child) {
        final List months = api.userModel.months;

        return Container(
          height: _height,
          width: _width,
          color: colors.blueColor,
          child: Column(
            children: [
              Container(
                color: colors.blueColor,
                height: _height * 0.3,
                width: _width,
                child: Image.asset("assets/analyze.png"),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                ),
                height: _height * 0.7,
                width: _width,
                child: ListView.builder(
                    itemCount: months.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      String currentYear =
                          months[index].toString().substring(1);
                      String currentMonth = monthsReference[
                          int.parse(months[index].toString()[0]) - 1];
                      String currentDate = currentMonth + " " + currentYear;

                      return InkWell(
                        onTap: () {
                          Get.to(() => AnalyzeMonth(
                                date: months[index],
                              ));
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(3.0, 1.0, 3.0, 0),
                          width: _width,
                          height: _height * 0.1,
                          child: Card(
                            color: colors.greyColor,
                            child: Center(
                              child: _widgets.text(
                                val: currentDate,
                                fontsize: 16.0,
                                color: colors.blueColor,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ))
            ],
          ),
        );
      }),
    );
  }
}
