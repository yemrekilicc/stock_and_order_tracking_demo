import 'dart:async';
import '../../constants/user_constants.dart';
import '../../init/navigation/navigation_service.dart';
import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {

  bool _isLoading = true;
  bool _isDisposed = false;
  bool _isInitializeDone = false;
  BuildContext? context;
  NavigationService navigation = NavigationService.instance;
  //LocaleManager localeManager = LocaleManager.instance;
  UserConstants? userConstants = UserConstants.instance;
  FutureOr<void> _initState;

  FutureOr<void> init();

  void setContext(BuildContext context);

  void changeStatus() {
    isLoading = !isLoading;
    //notifyListeners();
  }

  void reloadState() {
    if (!isLoading) notifyListeners();
  }

  void disposeFunction (){}

  @override
  void dispose() {
    changeStatus();
    _isDisposed = true;
    disposeFunction();
    super.dispose();
  }

  //Getters
  FutureOr<void> get initState => _initState;

  bool get isLoading => _isLoading;
  bool get isDisposed => _isDisposed;
  bool get isInitialized => _isInitializeDone;
  set isInitialized(bool value) {
    _isInitializeDone = value;
  }
  //Setters
  set isLoading(bool value) {
    _isLoading = value;
    scheduleMicrotask(() {
      if (!_isDisposed) notifyListeners();
    });
  }
}
