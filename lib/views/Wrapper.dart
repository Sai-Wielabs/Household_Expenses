import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/constants/colors.dart';
import 'package:household_expences/views/Login.dart';
import 'package:household_expences/views/Signup.dart';

class Wrapper extends StatelessWidget {
  final ConstantColors colors = ConstantColors();


  final Widgets _widgets = Widgets();

  @override
  build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: _widgets.text(
          val: "Household Expenses",
          color: colors.greyColor,
          fontsize: 24.0,
        ),
        backgroundColor: colors.blueColor,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: colors.blueColor,
      body: Container(
        height: _height - AppBar().preferredSize.height,
        width: _width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      height: _height * 0.5,
                      width: _width,
                      child: Center(
                        child: Image.asset(
                          "assets/shopping.png",
                          height: _height * 0.9,
                          width: _width * 0.8,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                    Container(
                      height: _height * 0.4,
                      width: _width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: _width * 0.9,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _widgets.text(
                                        color: colors.greyColor,
                                        fontsize: 32.0,
                                        val: "Ready to save"),
                                    _widgets.text(
                                        val:
                                            "Track your expenses the smart way",
                                        color: Color(0xffeeeeee),
                                        fontsize: 16.0),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                width: _width * 0.9,
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
                                width: _width * 0.9,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
