import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/constants/colors.dart';
import 'package:household_expences/models/FireDatabaseApi.dart';
import 'package:household_expences/services/FirebaseAuth.dart';
import 'package:household_expences/views/Signup.dart';
import 'package:household_expences/views/Wrapper.dart';
import 'package:household_expences/views/forgotPasswordScreen.dart';
import 'package:household_expences/views/home.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Color _blueColor = Colors.blue[900];
  final Color _greyColor = Color(0xffeeeeee);
  final Color _primaryColor = Color(0xFF7D30FA);
  final ConstantColors colors = ConstantColors();
  // ignore: unused_field
  final Color _secondaryColor = Color(0xFFF9CE69);

  final Widgets _widgets = Widgets();
  final FirebaseAuthservice _firebaseAuthservice = FirebaseAuthservice();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Consumer<FireApi>(
      builder: (context, api, child) => Scaffold(
        backgroundColor: _blueColor,
        body: Container(
          //color: _greyColor,
          height: _height,
          width: _width,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  top: 20.0,
                  left: _width * 0.01,
                  child: IconButton(
                    icon: Icon(
                      Icons.chevron_left_outlined,
                      color: _greyColor,
                      size: 38.0,
                    ),
                    onPressed: () {
                      Get.offAll(() => Wrapper());
                    },
                  ),
                ),
                Column(
                  children: [
                    Container(
                      //top container

                      height: _height * 0.45,
                      width: _width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: _height * 0.2,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: _width * 0.05),
                            width: _width,
                            child: _widgets.text(
                              val: "Welcome",
                              color: _greyColor,
                              fontsize: 38.0,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: _width * 0.05),
                            width: _width,
                            child: _widgets.text(
                              val: "Back",
                              color: _greyColor,
                              fontsize: 38.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: _height * 0.55,
                      width: _width,
                      child: Column(
                        children: [
                          //for text feilds
                          Container(
                            padding: EdgeInsets.all(_width * 0.05),
                            height: _height * 0.31,
                            width: _width,
                            // color: Colors.red,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _widgets.signupTextfeild(
                                  action: TextInputAction.next,
                                  textInputType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  iconColor: _greyColor,
                                  labelColor: _greyColor,
                                  hint: "email",
                                  borderColor: _greyColor,
                                  icon: Icons.email,
                                  key: Key("loginEmailField"),
                                ),
                                Padding(padding: EdgeInsets.all(4.0)),
                                _widgets.passwordTextfeild(
                                  lableColor: colors.greyColor,
                                  callback: () {
                                    api.virePassword();
                                  },
                                  action: TextInputAction.done,
                                  key: Key("loginPassFeild"),
                                  borderColor: _greyColor,
                                  controller: _passwordController,
                                  iconColor: _greyColor,
                                  hint: "password",
                                  icon: api.isPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.all(8.0),
                                  width: _width,
                                  child: InkWell(
                                    onTap: () async {
                                      Get.to(() => ForgotPassword());
                                    },
                                    child: _widgets.text(
                                      fontsize: 16.0,
                                      key: Key("forgotPassword"),
                                      color: colors.greyColor,
                                      val: "forgot password",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          //for login and signup buttons
                          SizedBox(
                            height: _height * 0.07,
                          ),
                          Container(
                            height: _height * 0.15,
                            width: _width,
                            // color: Colors.blue,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: _width * 0.9,
                                  height: _height * 0.05,
                                  child: RaisedButton(
                                    key: Key("loginButton"),
                                    color: colors.greyColor,
                                    onPressed: () async {
                                      String responce =
                                          await _firebaseAuthservice
                                              .firebaseLogin(
                                                  email: _emailController.text
                                                      .toString(),
                                                  password: _passwordController
                                                      .text
                                                      .toString());
                                      if (responce == "1") {
                                        _widgets.successToste(
                                            message:
                                                "User logged in successfully");
                                        Get.offAll(Home());
                                      } else {
                                        responce = responce.substring(
                                            responce.indexOf("]") + 2);
                                        _widgets.warningToste(
                                            message: responce);

                                        _emailController.clear();
                                        _passwordController.clear();
                                      }
                                    },
                                    child: _widgets.text(
                                        color: Colors.black,
                                        fontsize: 16.0,
                                        val: "Login"),
                                  ),
                                ),
                                Container(
                                  height: _height * 0.05,
                                  width: _width * 0.9,
                                  child: RaisedButton(
                                    color: Colors.pink,
                                    onPressed: () {
                                      Get.to(() => Signup());
                                    },
                                    child: _widgets.text(
                                      color: _greyColor,
                                      fontsize: 16.0,
                                      val: "Register",
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getBar({double height, String message, double width}) {
    message = message.substring(message.indexOf("]") + 2);
    return Get.showSnackbar(
      GetBar(
        message: message,
        backgroundColor: _greyColor,
        duration: Duration(milliseconds: 4000),
        userInputForm: Form(
          child: Container(
            height: height * 0.5,
            width: width,
            child: Center(
              child: _widgets.text(
                  color: _primaryColor, fontsize: 16.0, val: message),
            ),
          ),
        ),
      ),
    );
  }
}
