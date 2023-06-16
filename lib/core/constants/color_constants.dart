import 'package:flutter/material.dart';

class ColorConstants {
  static ColorConstants _instance = ColorConstants._init();
  static ColorConstants get instance => ColorConstants._instance;
  Color backgroundColor=Colors.grey.shade100;
  Color textFieldBackgroundColor=Colors.grey.shade200;
  Color textFieldBorderColor=Colors.grey.shade400;
  Color softTextColor=Colors.grey.shade400;
  Color textFieldColor=const Color(0xff16225f);
  Color buttonColor=const Color(0xffFFA62B);
  Color searchBarColor=const Color(0xff16697A);
  Color drawerTopColor=const Color(0xff89b7c0);
  Color siparisCardTopColor=const Color(0xffFFA62B);
  Color siparisCardDoneColor=const Color(0xFFD9E7CB);
  Color siparisCardNotDoneColor=const Color(0xfffce2e2);
  Color cancelColor=Colors.red.shade800;
  ColorConstants._init();
}
