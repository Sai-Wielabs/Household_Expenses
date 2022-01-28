import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:household_expences/models/models.dart';

class FireApi extends ChangeNotifier {
  UserModel userModel;
  List<FieldModel> currentFieldModel = [];
  List<String> categories = [];
  List<double> categoryTotals = [];
  List<double> fieldTotals = [];
  String currentCategory;
  String gender = "female";

  double aggregate = 0.0;
  bool isPassword = true;
  int index = 0;
  List<String> currentCategoryFields = [];
  final int month = DateTime.now().month;
  final int year = DateTime.now().year;
  String hint;

  void createUserModel({@required Map data}) {
    final String date = month.toString() + year.toString();
    print(data);

    final double currentMonthLimit =
        double.parse(data["monthlylimits"][date].toString()) ?? 0.0;

    userModel = UserModel(
      gender: data["gender"].toString(),
      monthlyBudgets: data["monthlylimits"],
      monthlyLimit: currentMonthLimit,
      months: data["months"],
      theme: data["theme"].toString(),
      userName: data["username"].toString(),
    );
    notifyListeners();
  }

  void createCategoriesModel({@required List<QueryDocumentSnapshot> data}) {
    List<String> tempCategories = [];
    List<double> tempCategoriesTotals = [];

    double tempAggregate = 0.0;
    data.forEach((element) {
      tempCategories.add(element.data()["categoryname"]);
      tempCategoriesTotals.add(element.data()["fieldtotal"]);
    });
    categories = tempCategories;
    categoryTotals = tempCategoriesTotals;

    categoryTotals.forEach((element) {
      tempAggregate += element;
    });
    aggregate = tempAggregate;

    notifyListeners();
  }

  void createFieldsModel(
      {@required List<QueryDocumentSnapshot> fields, String category}) {
    List<FieldModel> tempFieldModel = [];
    List<String> tempCategoryFields = [];
    fields.forEach((data) {
      tempCategoryFields.add(data.data()["fieldname"]);
      tempFieldModel.add(FieldModel(
        amount: data.data()["amount"],
        datecreated: data.data()["datecreated"],
        fieldName: data.data()["fieldname"],
        fieldTotal: data.data()["fieldtotal"],
        log: data.data()["log"],
      ));
    });
    currentFieldModel = tempFieldModel;
    currentCategoryFields = tempCategoryFields;
    currentCategory = category;
    notifyListeners();
  }

  void changeChipIndex({@required int currentIndex}) {
    index = currentIndex;
    notifyListeners();
  }

  void virePassword() {
    isPassword = !isPassword;
    notifyListeners();
  }

  updateDeletedFields({@required String categoryToDelete}) {
    List<String> currentCategories = categories;
    currentCategories.remove(categoryToDelete);
    if (currentCategories.length == 0) Get.back();
    categories = currentCategories;
    notifyListeners();
  }

  changeHint({String val}) {
    hint = val;
    notifyListeners();
  }

  changeGender({String updatedGender}) {
    gender = updatedGender;
    notifyListeners();
  }
}
