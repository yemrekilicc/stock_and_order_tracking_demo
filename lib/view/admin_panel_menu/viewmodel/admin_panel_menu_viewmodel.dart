import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/base/base_viewmodel/base_viewmodel.dart';

class AdminPanelMenuViewModel extends BaseViewModel{
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