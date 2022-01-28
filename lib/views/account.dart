import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/constants/colors.dart';
import 'package:household_expences/models/FireDatabaseApi.dart';
import 'package:household_expences/services/FirebaseAuth.dart';
import 'package:household_expences/services/FirebaseDatabase.dart';
import 'package:household_expences/views/Wrapper.dart';
import 'package:household_expences/views/analyze.dart';
import 'package:provider/provider.dart';
import 'package:household_expences/models/models.dart';

class Account extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuthservice _firebaseAuthservice = FirebaseAuthservice();
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase();
  final ConstantColors colors = ConstantColors();

  final Widgets _widgets = Widgets();

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: colors.blueColor,
      ),
      body: Consumer<FireApi>(
          builder: (BuildContext context, FireApi api, Widget child) {
        UserModel userModel = api.userModel;
        String username = userModel.userName ?? "Username";
        String gender = userModel.gender ?? "male";
        return Container(
          height: _height,
          width: _width,
          child: Stack(
            children: [
              assetPlacholder(context: context, gender: gender),
              Positioned(
                bottom: 0,
                child: Hero(
                  tag: "accountHero",
                  child: Container(
                    height: _height * 0.6,
                    color: Colors.white,
                    width: _width,
                    child: Column(
                      children: [
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _widgets.customCard(
                                context: context,
                                actionCallback: () {
                                  _widgets.customToaste(
                                    message: "This feature will available soon",
                                    messagecolor: colors.whiteColor,
                                    icon: Icons.info_outlined,
                                    iconColor: colors.whiteColor,
                                  );
                                },
                                actionIcon: Icons.switch_account,
                                titleName: "Switch user",
                              ),
                              _widgets.customCard(
                                context: context,
                                actionCallback: () {
                                  _widgets.customToaste(
                                    message: "Pet will available soon",
                                    messagecolor: colors.whiteColor,
                                    icon: Icons.info_outlined,
                                    iconColor: colors.whiteColor,
                                  );
                                },
                                actionIcon: Icons.donut_large,
                                titleName: "Activate pet",
                              ),
                              _widgets.customCard(
                                actionCallback: () => Get.to(() => Analyze()),
                                actionIcon: Icons.analytics_outlined,
                                context: context,
                                titleName: "Analyze",
                              ),
                              _widgets.customCard(
                                actionCallback: () => deleteAccount(),
                                context: context,
                                actionIcon: Icons.delete_forever_outlined,
                                titleName: "Delete account",
                              ),
                              _widgets.customCard(
                                context: context,
                                actionCallback: () => logout(),
                                actionIcon: Icons.logout,
                                titleName: "Logout",
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              usernameCard(context: context, username: username),
            ],
          ),
        );
      }),
    );
  }

  Widget assetPlacholder({BuildContext context, String gender}) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Positioned(
      top: 0,
      child: Container(
        height: _height * 0.3,
        width: _width,
        decoration: BoxDecoration(
          color: colors.blueColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Image.asset(
          gender.toLowerCase() == "male"
              ? "assets/men_hi.png"
              : "assets/women_hi.png",
          width: _width * 0.8,
          height: _height * 0.35,
        ),
      ),
    );
  }

  Widget usernameCard({BuildContext context, String username}) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Positioned(
      left: _width * 0.1,
      bottom: _height * 0.62,
      child: Container(
        child: Card(
          child: Center(
            child: _widgets.text(
                color: colors.blueColor,
                fontsize: 22.0,
                val: username,),
          ),
          elevation: 5.0,
          color: colors.greyColor,
        ),
        height: _height * 0.1,
        width: _width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future logout() {
    return _widgets.customSnacbarWithtwoButtons(
      titleText: "Are you sure to logout !",
      primaryCallback: () => logoutAccountAction(),
      primaryButtonText: "logout",
      secondaryButtonText: "cancle",
      secondaryCallback: () => Get.back(),
      secondaryKey: Key("cancleLogoutKey"),
      primaryKey: Key("confirmLogoutKey"),
    );
  }

  logoutAccountAction() async {
    ConnectivityResult connectionState =
        await Connectivity().checkConnectivity();
    if (connectionState == ConnectivityResult.none) {
      Get.snackbar("Unable to process", "No internet connection");
    } else {
      var response = await _firebaseAuthservice.signOut();
      if (response == "1") {
        _widgets.successToste(message: "user successfully logged out");
        Get.back();
        Get.offAll(Wrapper());
      } else {
        response = response.substring(response.indexOf("]") + 2);
        _widgets.warningToste(message: response);
      }
    }
  }

  Future<dynamic> deleteAccount() {
    return _widgets.customSnacbarWithtwoButtons(
        titleText: "Are you sure to delete your account",
        primaryCallback: () => deleteAccountAction(),
        primaryButtonText: "delete",
        secondaryButtonText: "cancle",
        secondaryCallback: () => Get.back(),
        secondaryKey: Key("cancleDeleteaccountButton"),
        primaryKey: Key("deleteAccountButtonKey"));
  }

  deleteAccountAction() async {
    ConnectivityResult connectionState =
        await Connectivity().checkConnectivity();
    if (connectionState == ConnectivityResult.none) {
      Get.snackbar("Unable to process", "No internet connection");
    } else {
      final userId = _auth.currentUser.uid.toString();
      String responce = await _firebaseAuthservice.deleteAccount();
      if (responce == "1") {
        var res = await _firebaseDatabase.deleteUserDatabase(uid: userId);
        if (res == "1") {
          _widgets.successToste(message: "user successfully deleted");
          Get.back();
          Get.offAll(() => Wrapper());
        } else {
          responce = responce.substring(responce.indexOf("]") + 2);
          _widgets.warningToste(message: responce);
          Get.back();
        }
      } else {
        Get.back();
        responce = responce.substring(responce.indexOf("]") + 2);
        _widgets.warningToste(message: responce);
      }
    }
  }
}
