import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/constants/colors.dart';

class About extends StatelessWidget {
  final Widgets _widgets = Widgets();
  final ConstantColors colors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colors.blueColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: colors.blueColor,
        title: _widgets.text(
            val: "About", color: colors.greyColor, fontsize: 18.0),
      ),
      body: Container(
        color: colors.blueColor,
        height: _height,
        width: _width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: colors.greyColor,
                height: _height * 0.97 - AppBar().preferredSize.height,
                width: _width,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: _height * 0.1),
                  child: Column(
                    children: [
                      card(
                        heading: "Privacy Policy",
                        text:
                            """K Sai Kiran built the Household Expenses app as a Free app. This SERVICE is provided by K Sai Kiran at no cost and is intended for use as is.

This page is used to inform visitors regarding my policies with the collection, use, and disclosure of Personal Information if anyone decided to use my Service.

If you choose to use my Service, then you agree to the collection and use of information in relation to this policy. The Personal Information that I collect is used for providing and improving the Service. I will not use or share your information with anyone except as described in this Privacy Policy.
The terms used in this Privacy Policy have the same meanings as in our Terms and Conditions, which is accessible at Household Expenses unless otherwise defined in this Privacy Policy.""",
                      ),
                      card(
                        heading: "Information Collection and Use",
                        text:
                            """For a better experience, while using our Service, I may require you to provide us with certain personally identifiable information, including but not limited to Email. The information that I request will be retained on your device and is not collected by me in any way.""",
                      ),
                      card(
                        heading: "Changes to This Privacy Policy",
                        text:
                            """I may update our Privacy Policy from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Privacy Policy on this page.
This policy is effective as of 2021-06-26""",
                      ),
                      card(
                        heading: "Contact Us",
                        text:
                            "If you have any questions or suggestions about my Privacy Policy, do not hesitate to contact me at support@householdExpenses@gmail.com",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  card({
    String text,
    String heading,
  }) {
    return Container(
      width: Get.width,
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.0),
            alignment: Alignment.centerLeft,
            width: Get.width,
            child: _widgets.text(
              val: heading,
              fontsize: 20.0,
              color: colors.blueColor,
              key: UniqueKey(),
            ),
          ),
          Container(
            color: Colors.white10,
            padding: EdgeInsets.all(4.0),
            child: Text(
              text,
              softWrap: true,
              textAlign: TextAlign.left,
              textScaleFactor: 1,
            
              style: GoogleFonts.aBeeZee(
                color: Colors.black,
                fontSize: 16.0,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          )
        ],
      ),
    );
  }
}
