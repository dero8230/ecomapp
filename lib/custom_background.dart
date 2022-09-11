import 'package:eShop/app_properties.dart';
import 'package:flutter/material.dart';

class MainBackground extends CustomPainter {
  MainBackground();

  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;
    canvas.drawRect(Rect.fromLTRB(0, 0, width, height),
        Paint()..color = Colors.white.withOpacity(1));
    canvas.drawRect(Rect.fromLTRB(width - (width / 3), 0, width, height),
        Paint()..color = kPrimaryColor.withOpacity(.5));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class MainBackgroundx extends CustomPainter {
  MainBackgroundx();

  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;
    canvas.drawRect(Rect.fromLTRB(0, 0, width, height),
        Paint()..color = Colors.grey[50]!.withOpacity(.9));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
