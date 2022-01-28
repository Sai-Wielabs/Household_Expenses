import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:household_expences/CustomWidgets/Widgets.dart';

class Panda extends StatelessWidget {
  final Color _greyColor = Color(0xffeeeeee);
  //final Color _primaryColor = Color(0xFF7D30FA);
  final Widgets _widgets = Widgets();
  final Color _blueColor = Colors.blue[900];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 1.0,
          centerTitle: true,
          title: _widgets.text(
            val: "Pet",
            color: _greyColor,
            fontsize: 18.0,
          )),
      body: Container(
        height: height,
        width: width,
        color: _blueColor,
        child: CustomPaint(
          painter: CustomPanda(),
          size: MediaQuery.of(context).size,
        ),
      ),
    );
  }
}

class CustomPanda extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    RRect rect = RRect.fromLTRBR(size.height * 0.4, size.height * 0.5,
        size.width, size.height * 0.9, Radius.circular(20));
    Paint rectPaint = Paint()..color = Colors.white;
    canvas.drawRRect(rect, rectPaint);
    Paint eye1 = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.butt;
    canvas.drawCircle(Offset(50, 50), 20, eye1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
