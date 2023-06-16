import 'package:flutter/material.dart';

MaterialColor PrimaryMaterialColor = const MaterialColor(
  4293389296,
  <int, Color>{
    50: Color.fromRGBO(
      231,
      235,
      240,
      .1,
    ),
    100: Color.fromRGBO(
      231,
      235,
      240,
      .2,
    ),
    200: Color.fromRGBO(
      231,
      235,
      240,
      .3,
    ),
    300: Color.fromRGBO(
      231,
      235,
      240,
      .4,
    ),
    400: Color.fromRGBO(
      231,
      235,
      240,
      .5,
    ),
    500: Color.fromRGBO(
      231,
      235,
      240,
      .6,
    ),
    600: Color.fromRGBO(
      231,
      235,
      240,
      .7,
    ),
    700: Color.fromRGBO(
      231,
      235,
      240,
      .8,
    ),
    800: Color.fromRGBO(
      231,
      235,
      240,
      .9,
    ),
    900: Color.fromRGBO(
      231,
      235,
      240,
      1,
    ),
  },
);

ThemeData myTheme = ThemeData(
  fontFamily: "customFont",
  primaryColor: Color(0xffe7ebf0),
  primarySwatch: PrimaryMaterialColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        Color(0xffe7ebf0),
      ),
    ),
  ),
);
