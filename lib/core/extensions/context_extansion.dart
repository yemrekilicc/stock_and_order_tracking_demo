import 'dart:io';
import 'dart:math';

import 'package:siparis_takip_demo/core/constants/size_constants.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;
  TextTheme get primaryTextTheme => Theme.of(this).primaryTextTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  ThemeData get appTheme => Theme.of(this);
  MaterialColor get randomColor => Colors.primaries[Random().nextInt(17)];

  bool get isKeyBoardOpen => MediaQuery.of(this).viewInsets.bottom > 0;
  Brightness get appBrightness => MediaQuery.of(this).platformBrightness;

  double get textScaleFactor => MediaQuery.of(this).textScaleFactor;
}

extension MediaQueryExtension on BuildContext {
  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  double get lowValue => height * 0.01;
  double get normalValue => height * 0.03;
  double get mediumValue => height * 0.04;
  double get highValue => height * 0.1;

  bool get isWideScreen {
    if(width>SizeConstant.instance!.wideScreenWidth) {
      return true;
    } else {
      return false;
    }
  }
  bool get isVeryWideScreen {
    if(width>SizeConstant.instance!.veryWideScreenWidth) {
      return true;
    } else {
      return false;
    }
  }
  double dynamicWidth(double val) {
    if(width>SizeConstant.instance!.wideScreenWidth){
      return SizeConstant.instance!.wideScreenWidth * val;
    }
    else {
      return width * val;
    }
  }
  double dynamicHeight(double val) => height * val;
}

//Device operating system checking with context value
extension DeviceOSExtension on BuildContext {
  bool get isAndroidDevice => Platform.isAndroid;
  bool get isIOSDevice => Platform.isIOS;
  bool get isWindowsDevice => Platform.isWindows;
  bool get isLinuxDevice => Platform.isLinux;
  bool get isMacOSDevicec => Platform.isMacOS;
}
