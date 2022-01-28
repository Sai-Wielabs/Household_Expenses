import 'package:flutter/material.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';

class LogScreen extends StatelessWidget {
  final List log;
  final String fieldName;
  LogScreen({this.log, this.fieldName});

  final Color _blueColor = Colors.blue[900];

  final Color _greyColor = Color(0xFFEEEEEE);
  final Widgets _widgets = Widgets();

  @override
  Widget build(BuildContext context) {
    print("log is $log");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: _blueColor,
        title: _widgets.text(
          val: fieldName,
          color: _greyColor,
          fontsize: 16.0,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        height: size.height,
        width: size.width,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            double amount = log[index]["amountadded"];
            String date = log[index]["date"] ?? log[index]["dateadded"];
            Color color = Colors.green;
            if (amount < 0) {
              color = Colors.red;
            }
            return Container(
              height: size.height * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _widgets.text(color: Colors.black, fontsize: 16.0, val: date),
                  _widgets.text(
                      color: color, fontsize: 16.0, val: amount.toString()),
                ],
              ),
            );
          },
          itemCount: log.length,
        ),
      ),
    );
  }
}
