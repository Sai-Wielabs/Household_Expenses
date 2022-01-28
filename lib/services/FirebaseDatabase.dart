import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/models/FireDatabaseApi.dart';
import 'package:household_expences/services/database.dart';

class FirebaseDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final DatabaseHelper streams = DatabaseHelper();
  final String month = DateTime.now().month.toString();
  final String year = DateTime.now().year.toString();
  final Widgets _widgets = Widgets();

//category related
  Future addCategory({
    @required String categoryName,
    @required TextEditingController categoryController,
  }) async {
    final String date = month + year;
    try {
      await _db
          .collection("users")
          .doc(_auth.currentUser.uid.toString())
          .collection(date)
          .doc(categoryName)
          .set(
        {
          "categoryname": categoryName,
          "fieldtotal": 0.0,
        },
      );

      Get.back();
      _widgets.successToste(message: "$categoryName added successfully");
      categoryController.clear();
    } catch (error) {
      print(error.toString());
      String message = error.substring(error.indexOf("]") + 2);
      _widgets.warningToste(message: message);
    }
  }

//field related operations
  Future addFeild({
    @required TextEditingController feildAmountController,
    @required TextEditingController feildController,
    @required String categoryName,
    @required String feildName,
    @required double amount,
  }) async {
    final String date = month + year;
    try {
      await _db
          .collection("users")
          .doc(_auth.currentUser.uid.toString())
          .collection(date)
          .doc(categoryName)
          .collection("fields")
          .doc(feildName)
          .set({
        "fieldname": feildName,
        "datecreated": DateTime.now().toString().substring(0, 10),
        "amount": amount,
        "log": [
          {
            "amountadded": amount,
            "date": DateTime.now().toString().substring(0, 10),
          }
        ]
      });
      DocumentSnapshot categoryRef = await _db
          .collection("users")
          .doc(_auth.currentUser.uid)
          .collection(date)
          .doc(categoryName)
          .get();
      double fieldtotal = categoryRef.data()["fieldtotal"] + amount;
      await _db
          .collection("users")
          .doc(_auth.currentUser.uid)
          .collection(date)
          .doc(categoryName)
          .update({"fieldtotal": fieldtotal});
      Get.back();

      _widgets.successToste(message: "successdully added $feildName");
      feildController.clear();
      feildAmountController.clear();
    } catch (error) {
      String responce = error.substring(error.indexOf("]") + 2);
      _widgets.warningToste(message: responce);

      feildController.clear();
      feildAmountController.clear();
      return error.toString();
    }
  }

  Future updateFeildValue({
    @required String fieldName,
    @required double fieldValue,
    @required String categoryName,
    @required String operation,
    @required TextEditingController controller,
  }) async {
    final String date = month + year;
    double currentTotal;
    double updatedTotal;
    double totalCategoryValue;
    try {
      DocumentSnapshot ref2 =
          await streams.categoryFieldsStream(categoryName: categoryName).get();
      totalCategoryValue = ref2.data()["fieldtotal"];

      DocumentSnapshot ref = await streams
          .categoryFieldsStream(categoryName: categoryName)
          .collection("fields")
          .doc(fieldName)
          .get();
      currentTotal = ref.data()["amount"];
      if (operation == "-") {
        updatedTotal = currentTotal - fieldValue;
        streams.categoryFieldsStream(categoryName: categoryName).update({
          "fieldtotal": totalCategoryValue - fieldValue,
        });
      } else {
        updatedTotal = currentTotal + fieldValue;
        streams.categoryFieldsStream(categoryName: categoryName).update({
          "fieldtotal": totalCategoryValue + fieldValue,
        });
      }

      await _db
          .collection("users")
          .doc(_auth.currentUser.uid.toString())
          .collection(date)
          .doc(categoryName)
          .collection("fields")
          .doc(fieldName)
          .update({
        "amount": updatedTotal,
        "log": FieldValue.arrayUnion(
          [
            {
              "amountadded": operation == "-" ? -fieldValue : fieldValue,
              "dateadded": DateTime.now().toString().substring(0, 10),
            }
          ],
        ),
      });

      Get.back();
      if (operation == "-") {
        _widgets.successToste(
            message:
                "Successfully decreased ${controller.text} from $fieldName");
      } else {
        _widgets.successToste(
            message: "Successfully added ${controller.text} to $fieldName");
      }
      controller.clear();
    } catch (error) {
      Get.back();
      String responce = error.substring(error.indexOf("]") + 2);
      _widgets.warningToste(message: responce);
      controller.clear();
    }
  }

  // Future updateFeildValue(
  //     {String feildName,
  //     int index,
  //     double fieldValue,
  //     String categoryName,
  //     double previousTotal}) async {
  //   try {
  //     List fields = [];
  //     double total = previousTotal + fieldValue;
  //     var reference =
  //         await _db.collection(_auth.currentUser.uid).doc(categoryName).get();
  //     reference.data().forEach((key, value) {
  //       if (key == "fields") {
  //         fields = value;
  //       }
  //     });
  //     fields[index]["amount"] = total;
  //     fields[index]["lastModifiedDate"] =
  //         DateTime.now().toString().substring(0, 10);

  //     await _db.collection(_auth.currentUser.uid).doc(categoryName).update({
  //       "fields": fields,
  //     });

  //     return "1";
  //   } catch (error) {
  //     return error.toString();
  //   }
  // }

  Future removeField({
    String fieldName,
    String categoryName,
  }) async {
    final String date = month + year;
    ConnectivityResult connectionState =
        await Connectivity().checkConnectivity();
    if (connectionState == ConnectivityResult.none) {
      _widgets.noInternetToaste();
    } else {
      try {
        DocumentSnapshot categoryRef = await _db
            .collection("users")
            .doc(_auth.currentUser.uid)
            .collection(date)
            .doc(categoryName)
            .collection("fields")
            .doc(fieldName)
            .get();

        var ref = await _db
            .collection("users")
            .doc(_auth.currentUser.uid)
            .collection(date)
            .doc(categoryName)
            .get();
        var changedAmount = categoryRef.data()["amount"];

        double total = ref.data()["fieldtotal"] - changedAmount;

        await _db
            .collection("users")
            .doc(_auth.currentUser.uid)
            .collection(date)
            .doc(categoryName)
            .update({
          "fieldtotal": total,
        });

        await _db
            .collection("users")
            .doc(_auth.currentUser.uid)
            .collection(date)
            .doc(categoryName)
            .collection("fields")
            .doc(fieldName)
            .delete();
        Get.back();
        _widgets.successToste(message: "Successfully deleted $fieldName");
      } catch (error) {
        return error.toString();
      }
    }
  }

  Future deleteCategory({
    @required String categoryName,
    @required FireApi ref,
  }) async {
    final String date = month + year;
    List<String> categoryFields = [];
    final String uid = _auth.currentUser.uid.toString();
    try {
      QuerySnapshot category = await _db
          .collection("users")
          .doc(uid)
          .collection(date)
          .doc(categoryName)
          .collection("fields")
          .get();
      category.docs.forEach((element) {
        categoryFields.add(element.data()["fieldname"]);
      });
      categoryFields.forEach((element) async {
        await _db
            .collection("users")
            .doc(uid)
            .collection(date)
            .doc(categoryName)
            .collection("fields")
            .doc(element)
            .delete();
      });
      await _db
          .collection("users")
          .doc(uid)
          .collection(date)
          .doc(categoryName)
          .delete();

      Get.back();
      ref.updateDeletedFields(categoryToDelete: categoryName);
      _widgets.successToste(message: "Successfullt Deleted $categoryName");
    } catch (error) {
      String response = error.substring(error.indexOf("]") + 2);
      _widgets.warningToste(message: response);
    }
  }

//
//
//user related operations
  Future updateUserName(
      {@required String userName,
      @required TextEditingController controller}) async {
    try {
      await _db
          .collection("users")
          .doc(_auth.currentUser.uid)
          .update({"username": userName});
      Get.back();
      _widgets.successToste(message: "UserName Updated to $userName");
      controller.clear();
    } catch (responce) {
      controller.clear();
      String message = responce.substring(responce.indexOf("]") + 2);
      _widgets.warningToste(message: message);
    }
  }

  Future<String> addUserName({String username}) async {
    print(username);
    try {
      await _db
          .collection("users")
          .doc(_auth.currentUser.uid)
          .update({"username": username});
      return "1";
    } catch (error) {
      return error.toString();
    }
  }

  Future<String> setMonthlyLimit({double limit}) async {
    try {
      final String date = month + year;

      final String uid = _auth.currentUser.uid.toString();
      DocumentSnapshot user = await _db.collection("users").doc(uid).get();
      Map monthlyLimits = user.data()["monthlylimits"];
      monthlyLimits["$date"] = double.parse(limit.toString());
      await _db.collection("users").doc(uid).update({
        "monthlylimits": monthlyLimits,
      });

      Get.back();
      return "1";
    } catch (error) {
      return error.toString();
    }
  }

  Future updateMonthlyLimit({
    @required double limit,
    @required TextEditingController controller,
  }) async {
    try {
      final uid = _auth.currentUser.uid.toString();
      final String date = month + year;
      var temp = await _db.collection("users").doc(uid).get();
      Map limits = temp.data()["monthlylimits"];
      limits[date] = double.parse(limit.toString());

      await _db
          .collection("users")
          .doc(_auth.currentUser.uid.toString())
          .update({
        "monthlylimits": limits,
      });

      Get.back();
      _widgets.successToste(message: "Successfully Updated Monthly Limit");
      controller.clear();
    } catch (responce) {
      String message = responce.substring(responce.indexOf("]") + 2);
      _widgets.warningToste(message: message);

      controller.clear();
    }
  }

  Future updateCollections({String currentCollection}) async {
    await streams.userStream().update({
      "months": FieldValue.arrayUnion([currentCollection])
    });
  }

  Future deleteUserDatabase({String uid}) async {
    try {
      await _db.collection("users").doc(uid).delete();
      return "1";
    } catch (error) {
      return error.toString();
    }
  }

  Future updateGender({@required TextEditingController controller}) async {
    final String gender = controller.text.toString();
    final String uid = _auth.currentUser.uid.toString();
    try {
      await _db.collection("users").doc(uid).update({"gender": gender});
      Get.back();
      controller.clear();
      _widgets.successToste(message: "Successfully updated gender");
    } catch (error) {
      String response =
          error.toString().substring(error.toString().indexOf("]") + 2);
      _widgets.warningToste(message: response);
    }
  }
}
