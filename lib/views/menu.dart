import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/actions/categoryactions.dart';
import 'package:household_expences/constants/colors.dart';
import 'package:household_expences/models/FireDatabaseApi.dart';
import 'package:household_expences/services/connectionService.dart';
import 'package:household_expences/services/database.dart';
import 'package:household_expences/views/about.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:household_expences/actions/userActions.dart';

class Menu extends StatelessWidget {
  final month = DateTime.now().month.toString();
  final year = DateTime.now().year.toString();
  final TextEditingController _limitController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final CheckConnection connectionService = CheckConnection();
  final DatabaseHelper streams = DatabaseHelper();
  final CategoryActions _categoryActions = CategoryActions();

  final Widgets _widgets = Widgets();
  final Color blueColor = Colors.blue[900];
  final ConstantColors colors = ConstantColors();
  final TextEditingController _updateUSerNameController =
      TextEditingController();
  final UserActions _userActions = UserActions();

  @override
  Widget build(BuildContext context) {
    final date = month + year;
    print(date);
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: blueColor,
        title: _widgets.text(
            val: "Settings", color: colors.greyColor, fontsize: 18.0),
      ),
      body: Consumer<FireApi>(
        builder: (context, api, child) {
          return Container(
            padding: EdgeInsets.all(5.0),
            height: _height,
            width: _width,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _widgets.customCard(
                    actionCallback: () => addLimitsnacbar(
                      categoriesSum: api.aggregate,
                    ),
                    context: context,
                    actionIcon: Icons.monetization_on_outlined,
                    titleName: "Update monthly limit",
                  ),
                  _widgets.customCard(
                    actionCallback: () => deleteCategorySnacbar(),
                    actionIcon: Icons.delete_outline_sharp,
                    context: context,
                    titleName: "Delete category",
                  ),
                  _widgets.customCard(
                    actionCallback: () {
                      _widgets.customSnacbarWithFieldAndButton(
                        height: Get.height,
                        width: Get.width,
                        controller: _updateUSerNameController,
                        callback: () {
                          _userActions.updateUserName(
                              controller: _updateUSerNameController);
                        },
                        fieldIcon: Icons.edit_outlined,
                        hintText: "update username",
                        buttonText: "update",
                        textInputType: TextInputType.visiblePassword,
                        fieldKey: Key("updateUserNameField"),
                        actionButtonKey: Key("updateUserNameButton"),
                      );
                    },
                    actionIcon: Icons.edit_outlined,
                    context: context,
                    titleName: "Rename account",
                  ),
                  _widgets.customCard(
                    actionCallback: () => {
                      _widgets.customSnacbarWithFieldAndButton(
                        height: Get.height,
                        width: Get.width,
                        controller: _genderController,
                        callback: () async {
                          await _userActions.updateGender(
                              controller: _genderController);
                        },
                        fieldIcon: Icons.edit_outlined,
                        hintText: "update gender",
                        buttonText: "update",
                        textInputType: TextInputType.visiblePassword,
                        fieldKey: Key("updateGenderField"),
                        actionButtonKey: Key("updateGenderButton"),
                      ),
                    },
                    actionIcon: Icons.edit_outlined,
                    context: context,
                    titleName: "Update gender",
                  ),
                  _widgets.customCard(
                    actionCallback: () async {
                      _widgets.customSnacbarWithtwoButtons(
                        titleText: "open mail applictaion",
                        primaryCallback: () async {
                          Get.back();
                          bool res = await launch(
                            "mailto:supportHouseholdExpenses@gmail.com?subject=Hi developer",
                          );
                          if (!res) {
                            _widgets.warningToste(
                                message:
                                    "unable to process please try after sometime");
                          }
                        },
                        primaryButtonText: "Mail",
                        secondaryButtonText: "cancle",
                        secondaryCallback: () => Get.back(),
                        secondaryKey: Key("cancleMail"),
                        primaryKey: Key("sendMail"),
                      );
                    },
                    actionIcon: Icons.contact_support_outlined,
                    context: context,
                    titleName: "Reach us",
                  ),
                  _widgets.customCard(
                    actionCallback: () => Get.to(() => About()),
                    actionIcon: Icons.info_outline_rounded,
                    context: context,
                    titleName: "About",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future deleteCategorySnacbar() async {
    if (Get.isSnackbarOpen) Get.back();

    final double height = Get.height;
    final double width = Get.width;
    return Get.showSnackbar(GetBar(
      snackStyle: SnackStyle.FLOATING,
      titleText: _widgets.text(
          val: "delete Fields", color: colors.blueColor, fontsize: 18.0),
      onTap: (obj) {},
      borderWidth: 1.0,
      leftBarIndicatorColor: blueColor,
      borderColor: blueColor,
      backgroundColor: Colors.white,
      dismissDirection: SnackDismissDirection.VERTICAL,
      borderRadius: 8.0,
      isDismissible: true,
      userInputForm: Form(
        child: Consumer<FireApi>(
            builder: (BuildContext context, FireApi api, Widget child) {
          return Container(
            width: width,
            height:
                api.categories.length == 0 ? height * 0.3 : Get.height * 0.5,
            child: api.categories.length == 0
                ? GestureDetector(
                    onVerticalDragDown: (val) {
                      Get.back();
                    },
                    child: Column(
                      children: [
                        _widgets.closeSnacbarShortcut(),
                        Container(
                          height: height * 0.2,
                          child: Center(
                            child: _widgets.text(
                                val: "No categories were added yet",
                                color: blueColor,
                                fontsize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(children: [
                      _widgets.closeSnacbarShortcut(),
                      Padding(padding: EdgeInsets.all(8.0)),
                      Container(
                        height: height * 0.5,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(bottom: Get.height * 0.1),
                          itemCount: api.categories.length,
                          itemBuilder: (context, index) {
                            return TweenAnimationBuilder<double>(
                              duration: Duration(milliseconds: index * 100),
                              tween: Tween<double>(begin: 100, end: 0),
                              builder: (context, value, child) =>
                                  Transform.translate(
                                offset: Offset(0, value),
                                child: Card(
                                  color: colors.greyColor,
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _widgets.text(
                                          val: api.categories[index],
                                          color: blueColor,
                                          fontsize: 16,
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: blueColor,
                                          ),
                                          onPressed: () async {
                                            _categoryActions.deleteCategory(
                                              apiReference: api,
                                              category: api.categories[index],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    height: height * 0.08,
                                    width: width * 0.95,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
          );
        }),
      ),
    ));
  }

  Future<dynamic> addLimitsnacbar({
    @required double categoriesSum,
  }) async {
    _widgets.customSnacbarWithFieldAndButton(
      height: Get.height,
      width: Get.width,
      controller: _limitController,
      callback: () {
        _userActions.updateMonthlyLimit(
            controller: _limitController, categoriesSum: categoriesSum);
      },
      fieldIcon: Icons.monetization_on_outlined,
      hintText: "update monthly limit",
      buttonText: "update",
      textInputType: TextInputType.number,
      fieldKey: Key("monthlyLimitUpdateField"),
      actionButtonKey: Key("monthlyLimitUpdateButton"),
    );
  }
}
