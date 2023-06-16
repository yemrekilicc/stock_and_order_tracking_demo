import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/base/base_viewmodel/base_viewmodel.dart';

class MainScreenViewModel extends BaseViewModel{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  FutureOr<void> init() {
    if (!isInitialized) {
      isInitialized = !isInitialized;
      changeStatus();
    }
  }

  @override
  void setContext(BuildContext context) {
  }
}