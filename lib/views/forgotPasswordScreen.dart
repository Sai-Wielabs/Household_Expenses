import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/constants/colors.dart';
import 'package:household_expences/services/FirebaseAuth.dart';
import 'package:household_expences/views/Login.dart';
import 'package:household_expences/views/Signup.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key key}) : super(key: key);
  final ConstantColors colors = ConstantColors();
  final Widgets _widgets = Widgets();
  final FirebaseAuthservice _authservice = FirebaseAuthservice();
  final TextEditingController _forgotPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    double _width = Get.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: colors.greyColor,
      ),
      backgroundColor: colors.blueColor,
      body: Container(
        height: Get.height,
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomPaint(
                painter: TopContainer(),
                child: Container(
                  height: Get.height * 0.17,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: Get.width,
                          child: _widgets.text(
                            val: "Hey, Chief",
                            fontsize: 38.0,
                            color: colors.blueColor,
                            key: Key("forgotQuote"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: Get.width,
                          child: _widgets.text(
                            val: "we got your back ",
                            fontsize: 32.0,
                            color: colors.blueColor,
                            key: Key("forgotQuote"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.17,
              ),
              Container(
                height: Get.height * 0.54,
                decoration: BoxDecoration(
                  color: colors.blueColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: _widgets.text(
                          val:
                              "we'll send an passsword reset link to your email",
                          color: colors.greyColor,
                          fontsize: 22.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.035,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: _widgets.signupTextfeild(
                          action: TextInputAction.done,
                          iconColor: colors.greyColor,
                          labelColor: colors.greyColor,
                          textInputType: TextInputType.emailAddress,
                          key: Key("forgotPasswordFieldKey"),
                          hint: "Email",
                          borderColor: colors.greyColor,
                          icon: Icons.email_outlined,
                          controller: _forgotPasswordController,
                        ),
                      ),
                    ),
                    Container(
                      width: Get.width * 0.95,
                      child: OutlineButton(
                        borderSide:
                            BorderSide(color: colors.greyColor, width: 1.0),
                        onPressed: () async {
                          String email =
                              _forgotPasswordController.text.toString();
                          if (email.isEmpty) {
                            _widgets.warningToste(
                                message: "Enter a valid email");
                          } else {
                            _authservice.forgotPassword(email: email);
                          }
                        },
                        child: _widgets.text(
                          val: "Send link",
                          color: colors.greyColor,
                          fontsize: 16.0,
                          key: Key("forgotPasswordActionButton"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.08,
                    ),
                    Column(
                      children: [
                        Container(
                          width: _width * 0.95,
                          child: RaisedButton(
                            key: Key("wrapperLoginButton"),
                            onPressed: () {
                              Get.to(() => Login());
                            },
                            color: colors.greyColor,
                            child: Text("Login"),
                          ),
                        ),
                        Container(
                          width: _width * 0.95,
                          child: RaisedButton(
                            key: Key("wrapperRegisterButton"),
                            onPressed: () {
                              Get.to(() => Signup());
                            },
                            color: Colors.pink,
                            child: _widgets.text(
                                color: colors.greyColor,
                                val: "Register",
                                fontsize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopContainer extends CustomPainter {
  final ConstantColors colors = ConstantColors();

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = Paint()..color = colors.greyColor;
    canvas.drawCircle(Offset(Get.width * 0.3, -100), Get.width * 0.75, circle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
