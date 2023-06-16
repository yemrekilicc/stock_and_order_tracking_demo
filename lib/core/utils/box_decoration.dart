import 'package:flutter/material.dart';

class CustomBoxDecoration {
  BoxDecoration serviceHome(Color color, double radius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: color,
    );
  }

  BoxDecoration serviceHomeAnimations(Color color, double radius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: color,
    );
  }

  BoxDecoration serviceHomeBorder(
      Color color, double width, double radius, Color borderColor) {
    return BoxDecoration(
      border: Border.all(color: borderColor, width: width),
      borderRadius: BorderRadius.circular(radius),
      color: color,
    );
  }

  BoxDecoration serviceHomeOnly(Color color, double topLeft, double topRight,
      double bottomLeft, double bottomRight) {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      ),
      color: color,
    );
  }
}
