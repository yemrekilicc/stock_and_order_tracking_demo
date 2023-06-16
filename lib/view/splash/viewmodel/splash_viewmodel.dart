import 'dart:async';
import 'package:siparis_takip_demo/core/constants/text_constants.dart';
import 'package:siparis_takip_demo/core/extensions/string_extansion.dart';
import 'package:siparis_takip_demo/core/init/firebase/auth.dart';
import 'package:siparis_takip_demo/core/init/firebase/query.dart';
import 'package:siparis_takip_demo/core/init/navigation/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_viewmodel/base_viewmodel.dart';
import '../../../core/constants/navigation_constant.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SplashViewModel extends BaseViewModel {
  bool islogin=true;
  @override
  FutureOr<void> init() async {
    if (!isInitialized) {
      isInitialized = !isInitialized;
      changeStatus();
    }

    Future.delayed(
      const Duration(milliseconds: 500),
      () {
      },
    ).then((value) => FirebaseAuth.instance.userChanges().listen((user) async {
      if(user!=null){

        //await Querys.instance.createStok();

        if(islogin){
          await AuthModel.instance.readUserInfo();
          CustomText.tableHierarchy=await Querys.instance.getTableHierarchy();
          for(var element in CustomText.tableHierarchy){
            CustomText.allTablesString[element["tableName"]]=await Querys.instance.getTableValues("${element["tableValueName"]}".capitalize());
          }
          if(kIsWeb)
          {
            NavigationService.instance.navigateToPageClear(path: NavigationConstants.CREATEORDER);
          }
          else{
            NavigationService.instance.pushReplacementNamed(path: NavigationConstants.MAINSCREEN);
            // await Querys.instance.createcesit();
            // await Querys.instance.createebat();
            // await Querys.instance.createsube();
          }
          islogin=false;
        }

      }
      else {
        islogin=true;
        NavigationService.instance.navigateToPageClear(path: NavigationConstants.LOGIN);
      }
    }));
  }
  // Future<List<String>> getCesitDropDownValues() async {
  //   return Querys.instance.getCesitNames();
  // }
  //
  // Future<List<String>> getSubeDropDownValues() async {
  //   return Querys.instance.getSubeNames();
  // }
  //
  // Future<List<String>> getEbatDropDownValues() async {
  //   return Querys.instance.getEbatNames();
  // }
  @override
  void setContext(BuildContext context) => this.context = context;
}
