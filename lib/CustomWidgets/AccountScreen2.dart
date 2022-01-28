import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';
import 'package:household_expences/constants/colors.dart';
import 'package:household_expences/models/FireDatabaseApi.dart';
import 'package:provider/provider.dart';

class AccountScreen2 extends StatelessWidget {
  AccountScreen2({Key key}) : super(key: key);

  final ConstantColors colors = ConstantColors();
  final Widgets _widgets = Widgets();

  @override
  Widget build(BuildContext context) {
    return Consumer<FireApi>(builder: (context, api, child) {
      return Scaffold(
        backgroundColor: colors.blueColor,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0.0,
              child: Container(
                height: Get.height * 0.4,
                width: Get.width,
                color: colors.blueColor,
                child: Center(
                  child: _widgets.text(
                      val: "May 2021", color: colors.greyColor, fontsize: 32),
                  // child: Image.asset(
                  //   "assets/men_hi.png",
                  //   width: Get.width * 0.8,
                  //   height: Get.height * 0.35,
                  // ),
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: Get.width * 0.01,
              child: Container(
                height: Get.height * 0.65,
                width: Get.width * 0.98,
                decoration: BoxDecoration(
                  color: colors.greyColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      if (api.categories.length != 0)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _widgets.text(
                            val: api.categories[api.index],
                            color: colors.blueColor,
                            fontsize: 18.0,
                          ),
                        ),
                      if (api.categories.length != 0)
                        Container(
                          margin: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: colors.blueColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                          ),
                          // padding: EdgeInsets.all(8.0),
                          height: Get.height * 0.1,
                          width: Get.width,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: api.categories.length ?? 0,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return TweenAnimationBuilder<double>(
                                  duration: Duration(milliseconds: 200),
                                  tween: Tween<double>(begin: 0, end: 1),
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      origin: Offset(0, 0),
                                      scale: value,
                                      child: InkWell(
                                        onTap: () => api.changeChipIndex(
                                            currentIndex: index),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Chip(
                                            label: _widgets.text(
                                              val: api.categories[index],
                                              color: api.index == index
                                                  ? colors.greenColor
                                                  : colors.blackColor,
                                              fontsize: 16.0,
                                            ),
                                            elevation:
                                                index == api.index ? 16.0 : 8.0,
                                            padding: const EdgeInsets.all(8.0),
                                            backgroundColor: api.index == index
                                                ? colors.whiteColor
                                                : colors.greyColor,
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                        ),
                      Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              _widgets.customCard(
                                context: context,
                                actionCallback: () async {},
                                actionIcon: Icons.analytics,
                                titleName: "Analyze",
                              ),
                              _widgets.customCard(
                                context: context,
                                actionCallback: () {},
                                actionIcon: Icons.logout,
                                titleName: "Logout",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
