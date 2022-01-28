import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/constants/colors.dart';
import 'package:household_expences/models/FireDatabaseApi.dart';
import 'package:household_expences/services/FirebaseDatabase.dart';
import 'package:household_expences/services/connectionService.dart';
import 'package:household_expences/services/database.dart';

import 'package:household_expences/views/logScreen.dart';
import 'package:household_expences/views/menu.dart';
import 'package:provider/provider.dart';

class ViewCategoryUi extends StatelessWidget {
  final String category;
  final String tag;
  ViewCategoryUi({this.category, this.tag});
  final month = DateTime.now().month.toString();
  final year = DateTime.now().year.toString();
  final ConstantColors colors = ConstantColors();
  final Widgets _widgets = Widgets();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final DatabaseHelper streams = DatabaseHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase();
  final TextEditingController _updateFieldController = TextEditingController();
  final TextEditingController _feildController = TextEditingController();
  final TextEditingController _feildAmountController = TextEditingController();
  final Widgets widgets = Widgets();
  final CheckConnection connectionHelper = CheckConnection();
  final Menu menuHelper = Menu();
  final String date =
      DateTime.now().month.toString() + DateTime.now().year.toString();

  @override
  Widget build(BuildContext context) {
    final date = month + year;
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colors.blueColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colors.blueColor,
        title: Wrap(
          children: [
            Container(
              width: _width * 0.3,
              child: _widgets.text(
                  val: category, color: colors.greyColor, fontsize: 18.0),
            ),
          ],
        ),
      ),
      body: Consumer<FireApi>(
        builder: (BuildContext context, FireApi api, child) {
          return StreamBuilder<QuerySnapshot>(
              stream: _db
                  .collection("users")
                  .doc(_auth.currentUser.uid.toString())
                  .collection(date)
                  .doc(category)
                  .collection("fields")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  );
                }
                //if (api.currentCategory != category)
                api.createFieldsModel(
                    fields: snapshot.data.docs, category: category);
                double fieldTotal = 0.0;
                api.currentFieldModel.forEach((element) {
                  fieldTotal += element.amount;
                });

                final double percentage =
                    (fieldTotal / api.userModel.monthlyLimit * 100);

                final double monthlyLimit = api.userModel.monthlyLimit;
                return Hero(
                  tag: tag,
                  child: Container(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          child: topContainer(
                              height: _height,
                              monthlyLimit: monthlyLimit,
                              percentage: percentage,
                              width: _width,
                              totalsum: fieldTotal),
                        ),
                        Positioned(
                          top: _height * 0.15,
                          child: bottomContainer(
                            context: context,
                            height: _height,
                            width: _width,
                          ),
                        ),
                        Positioned(
                          bottom: _height * 0.02,
                          right: _width * 0.05,
                          child: customFAB(
                            category: category,
                            height: _height,
                            width: _width,
                            context: context,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Widget customFAB({
    double height,
    double width,
    String category,
    BuildContext context,
    double monthlyLimit,
  }) {
    return Consumer<FireApi>(builder: (context, api, child) {
      return Container(
        padding: EdgeInsets.all(5.0),
        height: 50.0,
        width: width * 0.3,
        decoration: BoxDecoration(
          color: colors.blueColor,
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        child: InkWell(
          key: Key("addFieldButton"),
          onTap: () => addField(
            currentCategoryFields: api.currentCategoryFields.toList(),
            context: context,
            category: category,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: colors.greyColor,
              ),
              _widgets.text(
                color: colors.greyColor,
                fontsize: 16.0,
                val: "Field",
              )
            ],
          ),
        ),
      );
    });
  }

  Widget bottomContainer({
    double height,
    double width,
    BuildContext context,
  }) {
    return Consumer<FireApi>(
      builder: (BuildContext context, FireApi api, child) {
        return Container(
          width: width,
          padding: EdgeInsets.only(
            top: 5.0,
            left: 5.0,
            right: 5.0,
            bottom: 5.0,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          height: height * 0.9,
          child: api.currentFieldModel.length == 0
              ? Container(
                  height: height * 0.7,
                  width: width,
                  child: Center(
                    child: _widgets.text(
                        val: "Add a Entry",
                        color: colors.blueColor,
                        fontsize: 18),
                  ),
                )
              : ListView.builder(
                  addSemanticIndexes: true,
                  dragStartBehavior: DragStartBehavior.down,
                  addAutomaticKeepAlives: true,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  semanticChildCount: api.currentFieldModel.length,
                  itemExtent: 90,
                  key: Key("fieldsList"),
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom: height * 0.12 + 100.0,
                  ),
                  itemCount: api.currentFieldModel.length,
                  itemBuilder: (BuildContext context, int index) {
                    String fieldName = api.currentFieldModel[index].fieldName;
                    double fieldAmount = api.currentFieldModel[index].amount;
                    List<dynamic> log = api.currentFieldModel[index].log;
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: index * 100),
                      tween: Tween<double>(begin: 150, end: 0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          transformHitTests: true,
                          offset: Offset(0, value),
                          child: Dismissible(
                            key: Key("${"dismiss" + fieldName}"),
                            confirmDismiss: (direction) async {
                              _widgets.customSnacbarWithtwoButtons(
                                titleText: "confirm to delete $fieldName",
                                primaryCallback: () async {
                                  await _firebaseDatabase.removeField(
                                    fieldName: fieldName,
                                    categoryName: category,
                                  );
                                },
                                primaryButtonText: "delete",
                                secondaryButtonText: "cancle",
                                secondaryCallback: () => Get.back(),
                                secondaryKey: Key("cancleDeleteField"),
                                primaryKey: Key("confirmDeleteField"),
                              );
                              return false;
                            },
                            child: Card(
                              elevation: 2.0,
                              shadowColor: colors.greyColor,
                              color: colors.greyColor,
                              child: InkWell(
                                key: Key("${fieldName + "log"}"),
                                onTap: () {
                                  Get.to(() => LogScreen(
                                        log: log,
                                        fieldName: fieldName,
                                      ));
                                },
                                child: Container(
                                  height: height * 0.12,
                                  width: width,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            width: width * 0.5,
                                            child: _widgets.text(
                                              key: UniqueKey(),
                                              val: fieldName,
                                              color: colors.blueColor,
                                              fontsize: 16.0,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                removeButton(
                                                  fieldName: fieldName,
                                                  index: index,
                                                ),
                                                addButton(
                                                  fieldName: fieldName,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: colors.blueColor,
                                        height: 5.0,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.fromLTRB(
                                                15.0, 5.0, 15.0, 5.0),
                                            width: width * 0.5,
                                            child: _widgets.text(
                                              val: "Total",
                                              color: Colors.black,
                                              fontsize: 17.0,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                15.0, 5.0, 15.0, 5.0),
                                            child: _widgets.text(
                                              key: Key("addedAmount"),
                                              val: '${fieldAmount.round()}'
                                                  .toString(),
                                              color: Colors.black,
                                              fontsize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }

  Widget topContainer({
    double height,
    double width,
    double monthlyLimit,
    double percentage,
    double totalsum,
  }) {
    return Container(
      color: colors.blueColor,
      height: height * 0.15,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                width: width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _widgets.text(
                        val: "monthly budget   ${monthlyLimit.round()}",
                        color: colors.greyColor,
                        fontsize: 14.0),
                    _widgets.text(
                        val: percentage.round().toString() +
                            "%  " +
                            "(${totalsum.round()})",
                        color: colors.greyColor,
                        fontsize: 14.0),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
            ],
          ),
          Container(
            width: width * 0.9,
            color: colors.blueColor,
            child: Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: colors.greyColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              width: width * 0.9,
              child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: percentage / 100),
                  duration: Duration(milliseconds: 500),
                  builder: (BuildContext ctx, double x, Widget bar) {
                    return FractionallySizedBox(
                      widthFactor: x,
                      child: Container(
                        height: 15.0,
                        decoration: BoxDecoration(
                          color: colors.yellowColor,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget addButton({
    String fieldName,
  }) {
    return Consumer<FireApi>(
        builder: (BuildContext context, FireApi api, Widget child) {
      Size size = MediaQuery.of(context).size;
      return InkWell(
        key: Key("${"tinyAddButton" + fieldName}"),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xffeeeeee),
              ),
            ],
          ),
          width: size.width * 0.12,
          height: size.height * 0.05,
          child: Card(
            color: colors.yellowColor,
            elevation: 5.0,
            child: Icon(Icons.add),
          ),
        ),
        onTap: () async {
          _widgets.customSnacbarWithFieldAndButton(
            height: size.height,
            width: size.width,
            controller: _updateFieldController,
            callback: () => incrementValueAction(
              categorySum: api.aggregate,
              monthlyLimit: api.userModel.monthlyLimit,
              fieldName: fieldName,
            ),
            fieldIcon: Icons.monetization_on_outlined,
            hintText: "Add amount",
            buttonText: "Add",
            textInputType: TextInputType.number,
            fieldKey: Key("incrementFieldKey"),
            actionButtonKey: Key("incrementButtonKey"),
          );
        },
      );
    });
  }

  Future incrementValueAction({
    @required double categorySum,
    @required double monthlyLimit,
    @required String fieldName,
  }) async {
    ConnectivityResult connectionState =
        await Connectivity().checkConnectivity();
    if (connectionState == ConnectivityResult.none) {
      _widgets.noInternetToaste();
    } else {
      if (_updateFieldController.text.isEmpty ||
          !_updateFieldController.text.isNumericOnly) {
        _widgets.warningToste(message: "Please enter valid amount");
      } else {
        double total = double.parse(categorySum.toString()) +
            double.parse(_updateFieldController.text.toString());
        if (total > monthlyLimit) {
          _updateFieldController.clear();
          _widgets.customSnacbarWithtwoButtons(
            titleText: "monthly limit exceeded",
            primaryCallback: () {
              Get.back();
              Get.back();
              _updateFieldController.clear();
              menuHelper.addLimitsnacbar(
                categoriesSum: categorySum,
              );
              _updateFieldController.clear();
            },
            primaryButtonText: "update",
            secondaryButtonText: "cancle",
            secondaryCallback: () {
              Get.back();
            },
            secondaryKey: Key("updateCancleButton"),
            primaryKey: Key("UpdateLimitButton"),
          );
        } else {
          await _firebaseDatabase.updateFeildValue(
            controller: _updateFieldController,
            operation: "+",
            categoryName: category,
            fieldName: fieldName,
            fieldValue: double.parse(_updateFieldController.text),
          );
        }
      }
    }
  }

  Widget removeButton({
    int index,
    String fieldName,
  }) {
    return Consumer<FireApi>(
        builder: (BuildContext context, FireApi api, Widget child) {
      Size size = MediaQuery.of(context).size;
      return InkWell(
          key: Key("${"tinyRemoveButton" + fieldName}"),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xffeeeeee),
                ),
              ],
            ),
            width: size.width * 0.12,
            height: size.height * 0.05,
            child: Card(
              color: colors.yellowColor,
              elevation: 5.0,
              child: Icon(Icons.remove),
            ),
          ),
          onTap: () async {
            _widgets.customSnacbarWithFieldAndButton(
              height: size.height,
              width: size.width,
              controller: _updateFieldController,
              callback: () => decrementvalueAction(
                fieldName: api.currentFieldModel[index].fieldName,
                fieldTotal: api.currentFieldModel[index].amount,
              ),
              fieldIcon: Icons.monetization_on_outlined,
              hintText: "Decrease amount",
              buttonText: "Decrease",
              textInputType: TextInputType.number,
              fieldKey: Key("decreaseFieldKey"),
              actionButtonKey: Key("decreaseButtonKey"),
            );
          });
    });
  }

  Future decrementvalueAction({
    @required String fieldName,
    @required double fieldTotal,
  }) async {
    ConnectivityResult connectionState =
        await Connectivity().checkConnectivity();
    if (connectionState != ConnectivityResult.none) {
      double valueToBeRemoved =
          double.parse(_updateFieldController.text.toString());
      if ((fieldTotal - valueToBeRemoved) < 0) {
        _widgets.warningToste(
            message:
                "cannot decrease ${valueToBeRemoved.round()} from ${fieldTotal.round()}");
        _updateFieldController.clear();
      } else {
        await _firebaseDatabase.updateFeildValue(
          controller: _updateFieldController,
          operation: "-",
          categoryName: category,
          fieldName: fieldName,
          fieldValue: double.parse(_updateFieldController.text),
        );
      }
    } else {
      _widgets.noInternetToaste();
    }
  }

  PersistentBottomSheetController<dynamic> addField({
    @required String category,
    @required BuildContext context,
    @required List<String> currentCategoryFields,
  }) {
    return showBottomSheet(
      shape: OutlineInputBorder(
        borderSide: BorderSide(
          color: colors.blueColor,
          width: 2.0,
        ),
      ),
      context: context,
      builder: (context) {
        double height = Get.height;
        double width = Get.width;
        return Consumer<FireApi>(builder: (context, api, child) {
          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            )),
            padding: EdgeInsets.all(8.0),
            height: height * 0.35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _widgets.closeSnacbarShortcut(),
                _widgets.preSignupTextfeild(
                  action: TextInputAction.next,
                  borderColor: colors.blueColor,
                  controller: _feildController,
                  hint: "Field Name",
                  icon: Icons.text_fields_outlined,
                  iconColor: colors.blueColor,
                  key: Key("fieldNameField"),
                  labelColor: colors.blueColor,
                  textInputType: TextInputType.visiblePassword,
                ),
                _widgets.preSignupTextfeild(
                  action: TextInputAction.done,
                  borderColor: colors.blueColor,
                  controller: _feildAmountController,
                  hint: "Amount",
                  icon: Icons.monetization_on_outlined,
                  iconColor: colors.blueColor,
                  key: Key("fieldAmountField"),
                  labelColor: colors.blueColor,
                  textInputType: TextInputType.number,
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                  width: width * 0.9,
                  child: OutlineButton(
                      key: Key("addFieldButton"),
                      borderSide: BorderSide(
                        color: colors.blueColor,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                      child: _widgets.text(
                        color: colors.blueColor,
                        fontsize: 14.0,
                        val: "Add",
                      ),
                      onPressed: () async {
                        ConnectivityResult connectionState =
                            await Connectivity().checkConnectivity();
                        if (connectionState == ConnectivityResult.none) {
                          _widgets.noInternetToaste();
                        } else {
                          String field = _feildController.text.toString();
                          if (api.currentCategoryFields.contains(field)) {
                            String updatedField = findUpdatedCategory(
                              categoriesRef: currentCategoryFields,
                              categoryRef: field,
                            );

                            _widgets.customSnacbarWithtwoButtons(
                              titleText:
                                  "cannot add duplicate fields $field would you like to add $updatedField insted",
                              primaryCallback: () async {
                                Get.back();
                                double total =
                                    double.parse(_feildAmountController.text) +
                                        api.aggregate;
                                if (total > api.userModel.monthlyLimit) {
                                  _feildController.clear();
                                  _feildAmountController.clear();
                                  _widgets.customSnacbarWithtwoButtons(
                                    titleText: "monthly limit exceeded",
                                    primaryCallback: () {
                                      Get.back();
                                      Get.back();

                                      menuHelper.addLimitsnacbar(
                                        categoriesSum: api.aggregate,
                                      );
                                    },
                                    primaryButtonText: "update",
                                    secondaryButtonText: "cancle",
                                    secondaryCallback: () => Get.back(),
                                    secondaryKey: Key("updateCancleButton"),
                                    primaryKey: Key("UpdateLimitButton"),
                                  );
                                } else {
                                  await _firebaseDatabase.addFeild(
                                    categoryName: category,
                                    feildName: updatedField,
                                    amount: double.parse(
                                        _feildAmountController.text),
                                    feildAmountController:
                                        _feildAmountController,
                                    feildController: _feildController,
                                  );
                                }
                              },
                              primaryButtonText: "add",
                              secondaryButtonText: "cancle",
                              secondaryCallback: () => Get.back(),
                              secondaryKey: Key("cancleAddingDulicateField"),
                              primaryKey: Key(
                                "addDuplicate",
                              ),
                            );
                            _feildController.clear();
                          } else {
                            if (!_feildAmountController.text.isNumericOnly) {
                              _widgets.warningToste(
                                  message: "Please enter a valid amount");
                            } else {
                              double total =
                                  double.parse(_feildAmountController.text) +
                                      api.aggregate;
                              if (total > api.userModel.monthlyLimit) {
                                _feildController.clear();
                                _feildAmountController.clear();
                                _widgets.customSnacbarWithtwoButtons(
                                  titleText: "monthly limit exceeded",
                                  primaryCallback: () {
                                    Get.back();
                                    Get.back();

                                    menuHelper.addLimitsnacbar(
                                      categoriesSum: api.aggregate,
                                    );
                                  },
                                  primaryButtonText: "update",
                                  secondaryButtonText: "cancle",
                                  secondaryCallback: () => Get.back(),
                                  secondaryKey: Key("updateCancleButton"),
                                  primaryKey: Key("UpdateLimitButton"),
                                );
                              } else {
                                await _firebaseDatabase.addFeild(
                                  feildAmountController: _feildAmountController,
                                  feildController: _feildController,
                                  categoryName: category,
                                  feildName: _feildController.text.toString(),
                                  amount: double.parse(
                                    _feildAmountController.text.toString(),
                                  ),
                                );
                              }
                            }
                          }
                        }
                      }),
                ),
              ],
            ),
          );
        });
      },
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
}
