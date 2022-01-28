import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/models/FireDatabaseApi.dart';
import 'package:household_expences/services/FirebaseDatabase.dart';

class CategoryActions {
  final Widgets _widgets = Widgets();
  final double _height = Get.height;
  final double _width = Get.width;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase();
  void addCategoryToFirebase({
    @required TextEditingController controller,
    @required List categories,
  }) {
    _widgets.customSnacbarWithFieldAndButton(
      height: _height,
      width: _width,
      controller: controller,
      fieldIcon: Icons.text_fields_outlined,
      hintText: "Add category",
      buttonText: "Add",
      textInputType: TextInputType.visiblePassword,
      fieldKey: Key("addCategoryField"),
      actionButtonKey: Key("addCategoryButton"),
      callback: () async {
        var connectivityResult = await (Connectivity().checkConnectivity());
        String category = controller.text.toString();
        if (categories.contains(category)) {
          String updatedCategory = findUpdatedCategory(
                  categoriesRef: categories, categoryRef: category)
              .toString();

          _widgets.customSnacbarWithtwoButtons(
            titleText:
                "cannot add duplicate categories ($category) would you like to add $updatedCategory insted",
            primaryCallback: () async {
              Get.back();
              if (connectivityResult == ConnectivityResult.none) {
                _widgets.noInternetToaste();
              } else {
                if (updatedCategory.isEmpty) {
                  _widgets.warningToste(
                      message: "please add a valid category name");
                } else {
                  await _firebaseDatabase.addCategory(
                    categoryController: controller,
                    categoryName: updatedCategory,
                  );
                }
              }
            },
            primaryButtonText: "add",
            secondaryButtonText: "cancle",
            secondaryCallback: () => Get.back(),
            secondaryKey: Key("cancleAddingDuplicate"),
            primaryKey: Key("addDuplicateCategory"),
          );

          controller.clear();
        } else {
          if (connectivityResult == ConnectivityResult.none) {
            _widgets.noInternetToaste();
          } else {
            if (controller.text.isEmpty) {
              _widgets.warningToste(
                  message: "please add a valid category name");
            } else {
              await _firebaseDatabase.addCategory(
                categoryController: controller,
                categoryName: controller.text.toString(),
              );
            }
          }
        }
      },
    );
  }

  Future deleteCategory({
    @required String category,
    @required FireApi apiReference,
  }) async {
    ConnectivityResult connectionState =
        await Connectivity().checkConnectivity();
    if (connectionState == ConnectivityResult.none) {
      _widgets.noInternetToaste();
    } else {
      _widgets.customSnacbarWithtwoButtons(
        titleText: "Are you sure to delete $category",
        primaryCallback: () async {
          await _firebaseDatabase.deleteCategory(
            ref: apiReference,
            categoryName: category,
          );
          apiReference.updateDeletedFields(categoryToDelete: category);
        },
        primaryButtonText: "delete",
        secondaryButtonText: "cancle",
        secondaryCallback: () => Get.back(),
        secondaryKey: Key("cancleDeleteField"),
        primaryKey: Key("deleteField"),
      );
    }
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
