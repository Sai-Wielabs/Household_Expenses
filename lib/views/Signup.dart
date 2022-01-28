import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/constants/colors.dart';
import 'package:household_expences/models/FireDatabaseApi.dart';
import 'package:household_expences/services/FirebaseAuth.dart';
import 'package:household_expences/views/Login.dart';
import 'package:household_expences/views/Wrapper.dart';
import 'package:household_expences/views/home.dart';
import 'package:connectivity/connectivity.dart';
import 'package:provider/provider.dart';

class Signup extends StatelessWidget {
  final Widgets _widgets = Widgets();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameContrller = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final FirebaseAuthservice _firebaseAuthservice = FirebaseAuthservice();
  final ConstantColors colors = ConstantColors();
  @override
  build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: _width * 0.1,
        automaticallyImplyLeading: false,
        backgroundColor: colors.blueColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.to(() => Wrapper());
          },
        ),
      ),
      body: Consumer<FireApi>(
        builder: (context, api, child) => Container(
          height: _height,
          width: _width,
          color: colors.blueColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //name
                Container(
                  padding: EdgeInsets.all(Get.width * 0.05),
                  alignment: Alignment.centerLeft,
                  width: _width,
                  height: _height * 0.25,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: _widgets.text(
                            val: "Create",
                            color: colors.greyColor,
                            fontsize: 42.0,
                            key: Key("createAccountKey")),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: _widgets.text(
                            val: "Account",
                            color: colors.greyColor,
                            fontsize: 36.0,
                            key: Key("createAccountKey")),
                      ),
                    ],
                  ),
                ),
                //fields container
                Container(
                  decoration: BoxDecoration(
                    color: colors.blueColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  height: _height * 0.3,
                  width: _width,
                  child: Container(
                    width: _width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: _widgets.signupTextfeild(
                              action: TextInputAction.next,
                              key: Key("registerUsernameField"),
                              textInputType: TextInputType.text,
                              borderColor: colors.greyColor,
                              controller: _usernameContrller,
                              hint: "Username",
                              labelColor: colors.greyColor,
                              icon: Icons.account_circle_outlined,
                              iconColor: colors.greyColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: _widgets.signupTextfeild(
                              action: TextInputAction.next,
                              key: Key("registerEmailField"),
                              textInputType: TextInputType.emailAddress,
                              borderColor: colors.greyColor,
                              controller: _emailController,
                              hint: "email",
                              icon: Icons.email_outlined,
                              labelColor: colors.greyColor,
                              iconColor: colors.greyColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.9,
                            child: Consumer<FireApi>(
                                builder: (context, api, child) {
                              return _widgets.passwordTextfeild(
                                key: Key("registerPassswordfield"),
                                iconColor: colors.greyColor,
                                lableColor: colors.greyColor,
                                hint: "password",
                                borderColor: colors.greyColor,
                                icon: api.isPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                action: TextInputAction.done,
                                controller: _passwordController,
                                callback: () {
                                  api.virePassword();
                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: _widgets.customGemderSelector(),
                  ),
                ),
                SizedBox(
                  height: _height * 0.1,
                ),
                Container(
                  height: _height * 0.15,
                  child: Column(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0)),
                          width: _width * 0.8,
                          child: RaisedButton(
                            key: Key("registerButton"),
                            padding: EdgeInsets.all(10.0),
                            color: Colors.pink,
                            elevation: 5.0,
                            onPressed: () async {
                              ConnectivityResult connectionState =
                                  await Connectivity().checkConnectivity();
                              if (connectionState == ConnectivityResult.none) {
                                _widgets.noInternetToaste();
                              } else {
                                String _email =
                                    _emailController.text.toString();
                                String _password =
                                    _passwordController.text.toString();

                                String _username =
                                    _usernameContrller.text.toString();
                                if (_email.isEmpty ||
                                    _password.isEmpty ||
                                    _username.isEmpty) {
                                  if (_username.isEmpty) {
                                    _widgets.warningToste(
                                        message: "enter a valid username");
                                  } else if (_email.isEmpty) {
                                    _widgets.warningToste(
                                        message: "enter a valid email");
                                    _emailController.clear();
                                  } else if (_password.isEmpty) {
                                    _widgets.warningToste(
                                        message: "enter a valid password");
                                    _passwordController.clear();
                                  }
                                } else {
                                  String responce =
                                      await _firebaseAuthservice.firebaseSignup(
                                    email: _emailController.text.toString(),
                                    password:
                                        _passwordController.text.toString(),
                                    username:
                                        _usernameContrller.text.toString(),
                                    gender: api.gender,
                                  );
                                  print(api.gender);
                                  if (responce == "1") {
                                    _passwordController.clear();
                                    _emailController.clear();
                                    _usernameContrller.clear();
                                    _genderController.clear();

                                    Get.offAll(Home());
                                    _widgets.successToste(
                                        message:
                                            "user successfully registered");
                                  } else {
                                    responce = responce
                                        .substring(responce.indexOf("]") + 2);
                                    _emailController.clear();
                                    _widgets.warningToste(message: responce);
                                  }
                                }
                              }
                            },
                            child: _widgets.text(
                                fontsize: 16.0,
                                color: colors.greyColor,
                                val: "Register"),
                          ),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0)),
                          width: _width * 0.8,
                          child: RaisedButton(
                            elevation: 10.0,
                            padding: EdgeInsets.all(10.0),
                            color: colors.greyColor,
                            child: _widgets.text(
                              fontsize: 16.0,
                              color: colors.blueColor,
                              val: "Login",
                            ),
                            onPressed: () {
                              Get.to(() => Login());
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
