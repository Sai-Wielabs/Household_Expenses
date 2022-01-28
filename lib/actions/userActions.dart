import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/services/FirebaseDatabase.dart';

class UserActions {
  final Widgets _widgets = Widgets();
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase();

  Future updateGender({
    @required TextEditingController controller,
  }) async {
    final String gender = controller.text.toString();
    ConnectivityResult connectivityState =
        await Connectivity().checkConnectivity();
    if (connectivityState != ConnectivityResult.none) {
      if (gender.isEmpty) {
        _widgets.warningToste(message: "Enter a valid gender");
        controller.clear();
      } else {
        if (gender.toLowerCase() != "male" ||
            gender.toLowerCase() == "female") {
          _widgets.warningToste(message: "Enter a valid gender");
          controller.clear();
        } else {
          _firebaseDatabase.updateGender(
            controller: controller,
          );
        }
      }
    }
  }

  Future updateUserName({
    @required TextEditingController controller,
  }) async {
    final String userName = controller.text.toString();
    ConnectivityResult connectivityState =
        await Connectivity().checkConnectivity();
    if (connectivityState != ConnectivityResult.none) {
      if (userName.isEmpty) {
        _widgets.warningToste(message: "Enter a valid Username");
        controller.clear();
      } else {
        _firebaseDatabase.updateUserName(
          userName: userName,
          controller: controller,
        );
      }
    }
  }

  Future updateMonthlyLimit({
    @required TextEditingController controller,
    @required double categoriesSum,
  }) async {
    double amount = double.parse(controller.text.toString());
    if (controller.text.toString().isEmpty) {
      _widgets.warningToste(message: "Please enter a valid amount !");
    } else {
      ConnectivityResult connectionState =
          await Connectivity().checkConnectivity();
      if (connectionState != ConnectivityResult.none) {
        if (amount < categoriesSum ?? 0.0) {
          _widgets.warningToste(
              message:
                  "Cannot decrease monthly limit as you already has total of ${categoriesSum.round()}");
          controller.clear();
        } else {
         await _firebaseDatabase.updateMonthlyLimit(
              controller: controller, limit: double.parse(controller.text));
        }
      } else {
        _widgets.noInternetToaste();
      }
    }
  }
}
