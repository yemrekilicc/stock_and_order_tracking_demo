import 'package:flutter/material.dart';

import 'INavigation_service.dart';

class NavigationService implements INavigationService {
  static final NavigationService _instance = NavigationService._init();
  static NavigationService get instance => _instance;

  NavigationService._init();

  RoutePredicate get removeAllOldRoutes => (Route<dynamic> route) => false;
  @override
  Future<void> navigateToPage({required String path, Object? data}) async {
    await navigatorKey.currentState!.pushNamed(path, arguments: data);
  }

  @override
  void popPage() {
    navigatorKey.currentState!.pop();
  }
  Future<void> popAndPushNamedPage({required String path, Object? data}) async{
    await navigatorKey.currentState!.popAndPushNamed(path, arguments: data);
  }


  @override
  Future<void> navigateToPageClear({required String path, Object? data}) async {
    await navigatorKey.currentState!
        .pushNamedAndRemoveUntil(path, removeAllOldRoutes, arguments: data);
  }


  Future<void> pushReplacementNamed({required String path, Object? data}) async {
    await navigatorKey.currentState!
        .pushReplacementNamed(path, arguments: data);
  }

  Future<void> pushNamedAndRemoveUntil({required String path, Object? data}) async {
    await navigatorKey.currentState!
        .pushNamedAndRemoveUntil(path, (r) => false, arguments: data);
  }


  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
}
