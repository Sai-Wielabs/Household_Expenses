// import 'package:test/test.dart';
// import 'package:flutter_driver/flutter_driver.dart';

// void addCategory() {
//   group('add category and confirm it', () {
//     FlutterDriver driver;
//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });

//     final menuCategoryButton = find.byValueKey("menuCategoryButton");
//     final addCategoryField = find.byValueKey("addCategoryField");
//     final addCategoryButton = find.byValueKey("addCategoryButton");
//     final categoriesList = find.byValueKey("categoriesList");
//     final addedCategory = find.byValueKey("testCategory");

//     test("adding category", () async {
//       await driver.tap(menuCategoryButton);
//       await driver.tap(addCategoryField);
//       await driver.enterText("testCategory");
//       await driver.tap(addCategoryButton);

//       await driver.scrollUntilVisible(categoriesList, addedCategory,
//           dyScroll: -200);
//       expect(await driver.getText(addedCategory), "testCategory");
//     });
//     tearDownAll(() async {
//       driver.close();
//     });
//   });
// }

// void addMonthLimit() {
//   group("add monthly limit", () {
//     FlutterDriver driver;
//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });

//     final addLimitField = find.byValueKey("addLimitField");
//     final addLimitButton = find.byValueKey("addLimitButton");
//     final menuSetLimit = find.byValueKey("menuSetLimit");

//     test("add limit", () async {
//       await driver.tap(menuSetLimit);
//       await driver.tap(addLimitField);
//       await driver.enterText("5000");
//       await driver.tap(addLimitButton);
//     });
//     tearDownAll(() async {
//       driver.close();
//     });
//   });
// }

// void loginTest() {
//   group("login", () {
//     FlutterDriver driver;
//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });
//     final wrapperLoginButton = find.byValueKey("wrapperLoginButton");
//     final loginEmailField = find.byValueKey("loginEmailField");
//     final loginPassFeild = find.byValueKey("loginPassFeild");
//     final loginButton = find.byValueKey("loginButton");
//     test("login", () async {
//       await driver.tap(wrapperLoginButton);
//       await driver.tap(loginEmailField);
//       await driver.enterText("testcase@gamil.com");
//       await driver.tap(loginPassFeild);
//       await driver.enterText("123456");
//       await driver.tap(loginButton);
//     });

//     tearDownAll(() async {
//       await driver.close();
//     });
//   });
// }
