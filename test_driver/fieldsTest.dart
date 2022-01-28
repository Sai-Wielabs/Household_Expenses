

// import 'package:test/test.dart';
// import 'package:flutter_driver/flutter_driver.dart';

// void addField() {
//   group("add fields to category and opetate them", () {
//     FlutterDriver driver;
//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });
//    // final fieldsList = find.byValueKey("fieldsList");
//     //final addedField = find.byValueKey("fieldByTest4");
//    // final addFieldButton = find.byValueKey("addFieldButton"); 
//     //final fieldNameField = find.byValueKey("fieldNameField");
//    // final fieldAmountField = find.byValueKey("fieldAmountField");
//     final tinyAddButton = find.byValueKey("tinyAddButtonfieldByTest4");
//     final tinyRemoveButton = find.byValueKey("tinyRemoveButtonfieldByTest4");
//     final incrementFieldKey = find.byValueKey("incrementFieldKey");
//     final incrementButtonKey = find.byValueKey("incrementButtonKey");
//     final decreaseFieldKey = find.byValueKey("decreaseFieldKey");
//     final decreaseButtonKey = find.byValueKey("decreaseButtonKey");
//     final categoriesList = find.byValueKey("categoriesList");
//     final addedCategory = find.byValueKey("testCategory");
//     final logScreen = find.byValueKey("fieldByTest4log");

//     test("Add field to category and its operations", () async {
//       await driver.runUnsynchronized(() async {
//         //adding field to category
//         await driver.scrollUntilVisible(categoriesList, addedCategory,
//             dyScroll: -200);
//         await driver.tap(addedCategory);

//         // await driver.tap(addFieldButton);
//         // await driver.tap(fieldNameField);
//         // await driver.enterText("fieldByTest4");
//         // await driver.tap(fieldAmountField);
//         // await driver.enterText("70");
//         // await driver.tap(addFieldButton);

//         await driver.tap(tinyAddButton);
//         await driver.tap(incrementFieldKey);
//         await driver.enterText("10000");
//         await driver.tap(incrementButtonKey);

//         await driver.tap(tinyRemoveButton);
//         await driver.tap(decreaseFieldKey);
//         await driver.enterText("10000");

//         await driver.tap(decreaseButtonKey);
//         await driver.tap(logScreen);
//       });
//     });
//     tearDownAll(() async {
//       await driver.close();
//     });
//   });
// }

// void delete() async {
//   group("delete field", () {
//     FlutterDriver driver;
//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });
//     driver.runUnsynchronized(() async {
//       test("delete a field", () async {

//       });
//     });

//     tearDown(() async {
//       await driver.close();
//     });
//   });
// }
