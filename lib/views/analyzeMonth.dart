import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/constants/colors.dart';
import 'package:household_expences/services/database.dart';

class AnalyzeMonth extends StatelessWidget {
  final String date;
  AnalyzeMonth({this.date});

  final ConstantColors colors = ConstantColors();
  final Widgets _widgets = Widgets();
  final DatabaseHelper streams = DatabaseHelper();
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
  @override
  Widget build(BuildContext context) {
    String month = monthsReference[int.parse(date[0].toString()) - 1];
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    String currentDate =
        monthsReference[int.parse(date[0]) - 1] + " " + date.substring(1);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: colors.blueColor,
        title: _widgets.text(val: currentDate, fontsize: 18.0),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: streams.userStream(date: date).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> user) {
            double monthlyLimit = 0.0;

            if (user.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              );
            }
            monthlyLimit = double.parse(
                user.data.data()["monthlylimits"][date].toString());

            return StreamBuilder<QuerySnapshot>(
                stream: streams.categories(date: date).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> category) {
                  List categories = [];
                  double categoriesSum = 0.0;
                  if (category.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                      ),
                    );
                  }
                  category.data.docs.forEach((field) {
                    categories.add(field.data());
                    categoriesSum += field.data()["fieldtotal"];
                  });
                  int count = 0;
                  final double savedAmount = monthlyLimit - categoriesSum;

                  return Container(
                    color: colors.blueColor,
                    height: _height,
                    width: _width,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0.0,
                          child: Container(
                            padding: EdgeInsets.only(
                              top: _height * 0.1,
                              left: _height * 0.1,
                            ),
                            color: colors.blueColor,
                            height: _height * 0.4,
                            width: _width * 0.9,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: _height * 0.04,
                                  width: _width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _widgets.text(
                                          val: "$month Budget",
                                          color: colors.greyColor,
                                          fontsize: 18.0),
                                      _widgets.text(
                                        val: monthlyLimit.round().toString(),
                                        color: colors.greyColor,
                                        fontsize: 18.0,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: _width,
                                  height: _height * 0.06,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _widgets.text(
                                          val: "Saved Amount",
                                          color: colors.greyColor,
                                          fontsize: 18.0),
                                      _widgets.text(
                                          val: savedAmount.round().toString(),
                                          color: colors.greyColor,
                                          fontsize: 18.0),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          child: Container(
                            padding: EdgeInsets.only(
                                top: _height * 0.01, bottom: _height * 0.02),
                            color: colors.blueColor,
                            height: _height * 0.6,
                            width: _width,
                            child: categories.length == 0
                                ? Center(
                                    child: _widgets.text(
                                      val: "No Categories to display",
                                      color: colors.greyColor,
                                      fontsize: 18.0,
                                    ),
                                  )
                                : SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    padding: EdgeInsets.only(
                                      bottom: _height * 0.1,
                                      top: _height * 0.03,
                                    ),
                                    child: Column(
                                      children: categories.map(
                                        (category) {
                                          count++;
                                          String currentcategory =
                                              category["categoryname"];
                                          double currentFieldTotal =
                                              category["fieldtotal"];

                                          double percentage =
                                              currentFieldTotal / monthlyLimit;
                                          return TweenAnimationBuilder<double>(
                                              duration: Duration(
                                                  milliseconds: count * 200),
                                              tween: Tween<double>(
                                                  begin: 150, end: 0),
                                              builder: (context, value, child) {
                                                return Transform.translate(
                                                  offset: Offset(0.0, value),
                                                  child: Container(
                                                    height: _height * 0.06,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Container(
                                                          width: _width * 0.9,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              _widgets.text(
                                                                val:
                                                                    currentcategory,
                                                                fontsize: 16.0,
                                                                color: colors
                                                                    .greyColor,
                                                              ),
                                                              _widgets.text(
                                                                  val: currentFieldTotal
                                                                      .round()
                                                                      .toString(),
                                                                  fontsize:
                                                                      16.0,
                                                                  color: colors
                                                                      .greyColor)
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          height: 4.0,
                                                          width: _width * 0.9,
                                                          decoration:
                                                              BoxDecoration(
                                                            backgroundBlendMode:
                                                                BlendMode
                                                                    .screen,
                                                            color: colors
                                                                .greyColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  2.0),
                                                            ),
                                                          ),
                                                          child:
                                                              TweenAnimationBuilder(
                                                            duration: Duration(
                                                                milliseconds:
                                                                    500),
                                                            tween: Tween<
                                                                    double>(
                                                                begin: 0.0,
                                                                end:
                                                                    percentage),
                                                            builder:
                                                                (BuildContext
                                                                        context,
                                                                    double x,
                                                                    Widget
                                                                        bar) {
                                                              return FractionallySizedBox(
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .pink,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            2.0),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  widthFactor:
                                                                      x);
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                      ).toList(),
                                    ),
                                  ),
                          ),
                        ),
                        TweenAnimationBuilder(
                            tween: Tween<double>(begin: -50, end: -10),
                            duration: Duration(milliseconds: 500),
                            builder:
                                (BuildContext context, double x, Widget bar) {
                              return Positioned(
                                left: x,
                                top: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.yellow,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16.0))),
                                  height: _height * 0.3,
                                  width: _width * 0.15,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: _widgets.text(
                                      val: "Hey its $month",
                                      color: colors.blueColor,
                                      fontsize: 18.0,
                                    ),
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
