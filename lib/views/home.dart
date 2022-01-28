import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity/connectivity.dart';

import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/constants/colors.dart';
import 'package:household_expences/models/FireDatabaseApi.dart';
import 'package:household_expences/services/FirebaseDatabase.dart';
import 'package:household_expences/services/database.dart';
import 'package:household_expences/views/account.dart';
import 'package:household_expences/views/menu.dart';
import 'package:household_expences/models/models.dart';
import 'package:household_expences/views/viewcategoryUI.dart';
import 'package:provider/provider.dart';
import 'package:household_expences/actions/categoryactions.dart';

class Home extends StatelessWidget {
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase();
  final ConstantColors colors = ConstantColors();
  final _categoryController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final DatabaseHelper streams = DatabaseHelper();
  final Widgets _widgets = Widgets();
  final DatabaseHelper databaseHelper = DatabaseHelper();
  final String month = DateTime.now().month.toString();
  final String year = DateTime.now().year.toString();
  final CategoryActions _categoryActions = CategoryActions();
  final double _height = Get.height;
  final double _width = Get.width;

  Future<dynamic> addLimitsnacbar() {
    return _widgets.customSnacbarWithFieldAndButton(
      height: Get.height,
      width: Get.width,
      controller: _limitController,
      callback: () => addLimitAction(),
      fieldIcon: Icons.update_outlined,
      hintText: "Set Monthly Limit",
      buttonText: "set",
      textInputType: TextInputType.number,
      fieldKey: Key("addLimitField"),
      actionButtonKey: Key("addLimitButton"),
    );
  }

  String findUpdatedCategory(
      {@required List<String> categoriesRef, @required String categoryRef}) {
    List<String> categories = categoriesRef;
    String category = categoryRef;
    int length = category.length;
    String updatedCategory;
    if (categories.contains(category)) {
      if (length == 1) {
        if (category.isNumericOnly) {
          updatedCategory = (double.parse(category) + 1).toString();
        } else {
          updatedCategory = category + "1";
          if (categories.contains(updatedCategory)) {
            int tail = 0;
            String match = category;
            categories.forEach((field) {
              if (field.startsWith(match)) {
                if (field.length == updatedCategory.length) {
                  if (field.substring(field.length - 1).isNumericOnly) {
                    double lastnumber =
                        double.parse(field.substring(field.length - 1));
                    if (lastnumber.round() > tail) {
                      tail = lastnumber.round();
                    }
                  }
                }
              }
            });
            updatedCategory = category + (tail + 1).toString();
          }
        }
      } else {
        String lastCharacter = category.substring(length - 1);
        if (lastCharacter.isNumericOnly) {
          lastCharacter = (double.parse(lastCharacter).round() + 1).toString();
          updatedCategory = category.substring(0, length - 1) + lastCharacter;
          if (categories.contains(updatedCategory)) {
            int tail = 0;
            String match =
                updatedCategory.substring(0, updatedCategory.length - 1);
            categories.forEach((field) {
              if (field.startsWith(match)) {
                if (field.length == updatedCategory.length) {
                  if (field.substring(field.length - 1).isNumericOnly) {
                    double lastnumber =
                        double.parse(field.substring(field.length - 1));
                    if (lastnumber.round() > tail) {
                      tail = lastnumber.round();
                    }
                  }
                }
              }
            });
            updatedCategory = category.substring(0, category.length - 1) +
                (tail + 1).toString();
          }
        } else {
          updatedCategory = category + "1";
          if (categories.contains(updatedCategory)) {
            int tail = 0;
            String match =
                updatedCategory.substring(0, updatedCategory.length - 1);
            categories.forEach((field) {
              if (field.startsWith(match)) {
                if (field.length == updatedCategory.length) {
                  if (field.substring(field.length - 1).isNumericOnly) {
                    double lastnumber =
                        double.parse(field.substring(field.length - 1));
                    if (lastnumber.round() > tail) {
                      tail = lastnumber.round();
                    }
                  }
                }
              }
            });
            updatedCategory =
                updatedCategory.substring(0, updatedCategory.length - 1) +
                    (tail + 1).toString();
          }
        }
      }
      return updatedCategory;
    } else {
      return category;
    }
  }

  Future addLimitAction() async {
    ConnectivityResult connectionState =
        await Connectivity().checkConnectivity();
    if (connectionState == ConnectivityResult.none) {
      _widgets.noInternetToaste();
    } else {
      String responce = await _firebaseDatabase.updateMonthlyLimit(
          controller: _limitController,
          limit: double.parse(_limitController.text));

      if (responce == "1") {
        Get.back();
        _widgets.successToste(message: "monthly limit updated successfully");
        _limitController.clear();
      } else {
        Get.back();
        responce = responce.substring(responce.indexOf("]") + 2);
        _widgets.warningToste(message: responce);
        _limitController.clear();
      }
    }
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 1.0,
        shadowColor: colors.blueColor,
        backgroundColor: colors.blueColor,
        centerTitle: true,
        title: Text(
          "Household Expenses",
          style: GoogleFonts.aBeeZee(),
        ),
      ),
      body: Consumer<FireApi>(builder: (context, api, child) {
        final String date =
            DateTime.now().month.toString() + DateTime.now().year.toString();
        return Stack(
          children: [
            StreamBuilder<DocumentSnapshot>(
                stream: streams.userStream().snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> user) {
                  if (user.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    );
                  } else if (user.connectionState == ConnectionState.active) {
                    if (user.hasData) {
                      api.createUserModel(data: user.data.data());
                    }
                    return StreamBuilder<QuerySnapshot>(
                        stream: streams.categories(date: date).snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> categoriesStream) {
                          if (categoriesStream.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 5.0,
                              ),
                            );
                          } else if (categoriesStream.connectionState ==
                              ConnectionState.active) {
                            final UserModel userModel = api.userModel;
                            final List<dynamic> months = userModel.months;
                            api.createCategoriesModel(
                                data: categoriesStream.data.docs);
                            final List<String> categories = api.categories;
                            final List<double> categoryTotals =
                                api.categoryTotals;
                            double categoriesTotal =
                                double.parse(api.aggregate.toString());
                            int docsLenght = api.categories.length;
                            final double monthlyLimit = double.parse(
                                    userModel.monthlyLimit.toString()) ??
                                0.0;
                            double categoriesPercentage =
                                categoriesTotal / monthlyLimit * 100;

                            if (docsLenght == 0) {
                              if (!months.contains(date)) {
                                _firebaseDatabase.updateCollections(
                                    currentCollection: date);
                                _firebaseDatabase.setMonthlyLimit(limit: 0.0);
                              }
                            }
                            double percentage = (categoriesPercentage / 100);

                            return SingleChildScrollView(
                              child: Stack(
                                children: [
                                  Container(
                                    height: _height -
                                        AppBar().preferredSize.height -
                                        30.0,
                                    width: _width,
                                    color: colors.blueColor,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15.0),
                                              bottomRight:
                                                  Radius.circular(15.0),
                                            ),
                                            color: colors.blueColor,
                                          ),
                                          height: _height * 0.15,
                                          width: _width,
                                          child: monthlyLimit == 0.0 ||
                                                  monthlyLimit == 0
                                              ? selLimitContainer()
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    SizedBox(
                                                        height: _height * 0.03),
                                                    currentUserAmountIndicator(
                                                      monthlyLimit:
                                                          monthlyLimit,
                                                      categoriesPercentage:
                                                          categoriesPercentage,
                                                      categoriesTotal:
                                                          categoriesTotal,
                                                    ),
                                                    percentageBar(
                                                        percentage: percentage),
                                                    SizedBox(
                                                        height: _height * 0.01),
                                                  ],
                                                ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: colors.greyColor,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight: Radius.circular(20.0),
                                              ),
                                            ),
                                            margin: EdgeInsets.all(0.0),
                                            padding: EdgeInsets.all(5.0),
                                            height: _height,
                                            width: _width,
                                            child: docsLenght == 0
                                                ? Center(
                                                    child: Text(
                                                      "Welcome Ready To Track  😍 ",
                                                      style:
                                                          GoogleFonts.aBeeZee(
                                                        color: colors.blueColor,
                                                        fontSize: 18.0,
                                                      ),
                                                    ),
                                                  )
                                                : StaggeredGridView
                                                    .countBuilder(
                                                    addAutomaticKeepAlives:
                                                        true,
                                                    primary: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    key: Key("categoriesList"),
                                                    padding: EdgeInsets.only(
                                                        bottom: _height * 0.1),
                                                    mainAxisSpacing: 5.0,
                                                    crossAxisSpacing: 5.0,
                                                    itemCount: docsLenght,
                                                    crossAxisCount: 4,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      String categoryName =
                                                          categories[index]
                                                              .toString();

                                                      return TweenAnimationBuilder<
                                                              double>(
                                                          tween: Tween<double>(
                                                              begin: 0.7,
                                                              end: 1),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  400),
                                                          builder: (context,
                                                              value, child) {
                                                            return Transform
                                                                .scale(
                                                              origin: Offset(
                                                                0,
                                                                0,
                                                              ),
                                                              scale: value,
                                                              child: Container(
                                                                height:
                                                                    _height *
                                                                        0.1,
                                                                width: _width *
                                                                    0.9,
                                                                child:
                                                                    Container(
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      Get.to(
                                                                        () =>
                                                                            ViewCategoryUi(
                                                                          category:
                                                                              categoryName,
                                                                          tag: categoryName +
                                                                              index.toString(),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Card(
                                                                      elevation:
                                                                          3.0,
                                                                      shadowColor:
                                                                          Color(
                                                                              0xffeeeeee),
                                                                      child:
                                                                          Container(
                                                                        height: _height *
                                                                            0.1,
                                                                        width: _width *
                                                                            0.9,
                                                                        color: Color(
                                                                            0xcceeeeee),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(""),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                categoryName.toString(),
                                                                                key: Key("$categoryName"),
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: GoogleFonts.aBeeZee(fontSize: 16.0, color: colors.blueColor),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Text(""),
                                                                            ),
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(8.0),
                                                                                ),
                                                                              ),
                                                                              alignment: Alignment.centerLeft,
                                                                              width: _width * 0.9,
                                                                              height: 2.0,
                                                                              child: FractionallySizedBox(
                                                                                widthFactor: categoryTotals[index] / monthlyLimit,
                                                                                heightFactor: 1,
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: colors.yellowColor,
                                                                                    borderRadius: BorderRadius.all(
                                                                                      Radius.circular(8.0),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    staggeredTileBuilder:
                                                        (int index) {
                                                      return StaggeredTile
                                                          .count(
                                                        2,
                                                        index.isEven ? 1.5 : 1,
                                                      );
                                                    },
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    bottom: _height * 0.005,
                                    left: _width * 0.02,
                                    right: _width * 0.02,
                                    child: Card(
                                      color: Colors.transparent,
                                      elevation: 10,
                                      child: Container(
                                        padding: EdgeInsets.all(2.0),
                                        decoration: BoxDecoration(
                                          color: colors.blueColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        height: _height * 0.08,
                                        width: _width * 0.96,
                                        child: Container(
                                          margin: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: colors.greyColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              IconButton(
                                                  icon: Hero(
                                                    tag: "settingsHero",
                                                    child: Icon(
                                                      Icons.settings_outlined,
                                                      size: 26.0,
                                                      color: colors.blueColor,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Get.to(
                                                      () => Menu(),
                                                    );
                                                  }),
                                              IconButton(
                                                  icon: Hero(
                                                    tag: "accountHero",
                                                    child: Icon(
                                                      Icons
                                                          .account_circle_outlined,
                                                      size: 26.0,
                                                      color: colors.blueColor,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Get.to(() => Account());
                                                  }),
                                              IconButton(
                                                key: const Key(
                                                    "menuCategoryButton"),
                                                icon: Icon(
                                                  Icons.add,
                                                  size: 30.0,
                                                  color: colors.blueColor,
                                                ),
                                                onPressed: () async {
                                                  _categoryActions
                                                      .addCategoryToFirebase(
                                                          controller:
                                                              _categoryController,
                                                          categories:
                                                              api.categories);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (categoriesStream.hasError) {
                            return CircularProgressIndicator(
                              strokeWidth: 2.0,
                            );
                          }
                          return CircularProgressIndicator(
                            strokeWidth: 2.0,
                          );
                        });
                  } else if (user.hasError) {
                    return Center(
                      child: _widgets.text(
                          color: colors.blueColor,
                          fontsize: 16.0,
                          val: "Unable to process Please try after sometime"),
                    );
                  }
                  return CircularProgressIndicator(
                    strokeWidth: 2.0,
                  );
                }),
          ],
        );
      }),
    );
  }

  Widget percentageBar({@required double percentage}) {
    if (percentage < 0.02 && percentage > 0.0) {
      percentage = 0.02;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.greyColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          height: 15.0,
          alignment: Alignment.centerLeft,
          width: _width * 0.9,
          child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 500),
            tween: Tween<double>(end: percentage, begin: 0.0),
            builder: (BuildContext context, double x, Widget bar) {
              return FractionallySizedBox(
                widthFactor: x,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.yellowColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                  constraints: BoxConstraints(maxWidth: _width * 0.5),
                  height: 15.0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget currentUserAmountIndicator({
    @required monthlyLimit,
    @required categoriesPercentage,
    @required double categoriesTotal,
  }) {
    return Container(
      width: _width * 0.89,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _widgets.text(
              color: colors.greyColor,
              fontsize: 14.0,
              val: "monthly budget ${monthlyLimit.round()}"),
          _widgets.text(
              val:
                  "${categoriesPercentage.round()}%  (${categoriesTotal.round()})",
              color: colors.greyColor,
              fontsize: 14.0),
        ],
      ),
    );
  }

  Widget selLimitContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _widgets.text(
            val: "set monthly limit ", color: colors.greyColor, fontsize: 16.0),
        RaisedButton(
          key: Key("menuSetLimit"),
          elevation: 5.0,
          color: colors.greyColor,
          onPressed: () => addLimitsnacbar(),
          child: _widgets.text(
            color: colors.pinkColor,
            fontsize: 16.0,
            val: "Set",
          ),
        ),
      ],
    );
  }
}
