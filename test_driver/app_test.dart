// import 'package:test/test.dart';
// import 'package:flutter_driver/flutter_driver.dart';
// import 'categoriesTest.dart' as category;
// import 'fieldsTest.dart' as fields;
// //Flutter drive tests consist of 2 parts.
// // One part is code that runs in the emulator/device,
// //and the other part is code that drives the code from the former part.
// //The code in the later part can't import dart:ui,
// //not directly and not transitively.
// //just make sure your imports are
// // import 'package:flutter_driver/flutter_driver.dart'; and
// //import 'package:test/test.dart';
// // only add the baove two imports else dart:ui not fonud wil couur

// void main() {
//   register();
//   category.loginTest();
//   fields.addField();
//   category.addMonthLimit();
//   category.addCategory();
//   group("integration test for this app", () {
//     final loginEmailField = find.byValueKey("loginEmailField");
//     final loginPassFeild = find.byValueKey("loginPassFeild");
//     final addCategoryField = find.byValueKey("addCategoryField");
//     final loginButton = find.byValueKey("loginButton");
//     final wrapperLoginButton = find.byValueKey("wrapperLoginButton");
//     final addCategoryButton = find.byValueKey("addCategoryButton");
//     final addCategoryToFirebaseButton =
//         find.byValueKey("addCategoryToFirebaseButton");
//     final categoriesList = find.byValueKey("categoriesList");
//     final addedCategory = find.byValueKey("test");

//     FlutterDriver driver;

//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });

//     test("adding category to firebase", () async {
//       await driver.runUnsynchronized(() async {
//         await driver.tap(wrapperLoginButton);
//         await driver.tap(loginEmailField);
//         await driver.enterText("test@gmail.com");
//         await driver.tap(loginPassFeild);
//         await driver.enterText("123456");
//         await driver.tap(loginButton);
//         await driver.waitFor(addCategoryButton);
//         await driver.tap(addCategoryButton);
//         await driver.tap(addCategoryField);
//         await driver.enterText("test");
//         await driver.tap(addCategoryToFirebaseButton);
//         await driver.waitFor(categoriesList);
//         await driver.scrollUntilVisible(categoriesList, addedCategory,
//             dyScroll: -200);
//         expect(await driver.getText(addedCategory), "test");
//       });
//     });

//     //update field value

  
//     tearDownAll(() async {
//       driver.close();
//     });
//   });
// }

// void register() {
//   group("register ", () {
//     //initial
//     FlutterDriver driver;

//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });

//     final wrapperRegisterButton = find.byValueKey("wrapperRegisterButton");
//     final registerUsernameField = find.byValueKey("registerUsernameField");
//     final registerEmailField = find.byValueKey("registerEmailField");
//     final registerGenderField = find.byValueKey("registerGenderField");
//     final registerPasswordField = find.byValueKey("registerPasswordField");
//     final registerButton = find.byValueKey("registerButton");

//     test("sign up to firebase", () async {
//       await driver.tap(wrapperRegisterButton);
//       await driver.waitFor(registerUsernameField);
//       await driver.tap(registerUsernameField);
//       await driver.enterText("integration test");
//       await driver.tap(registerGenderField);
//       await driver.enterText("male");
//       await driver.tap(registerEmailField);
//       await driver.enterText("testcase@gamil.com");
//       await driver.tap(registerPasswordField);
//       await driver.enterText("123456");
//       await driver.tap(registerButton);
//     });

//     tearDownAll(() async {
//       driver.close();
//     });
//   });
// }
