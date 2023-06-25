import 'dart:async';

import 'package:siparis_takip_demo/core/base/base_viewmodel/base_viewmodel.dart';
import 'package:siparis_takip_demo/core/constants/color_constants.dart';
import 'package:siparis_takip_demo/core/constants/navigation_constant.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/init/firebase/auth.dart';
import 'package:siparis_takip_demo/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/base/base_view/base_view.dart';

class navigationDrawer extends StatelessWidget {
  const navigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<navigationDrawerViewModel>(
      viewModel: navigationDrawerViewModel(),
      onModelReady: (model) async {
        model.setContext(context);
        await model.init();
      },
      onPageBuilder: (context, viewModel, child) =>  buildBody(viewModel, context),
    );
  }

  Widget buildBody(navigationDrawerViewModel viewModel, BuildContext context) {
    return Drawer(

      shape: Border.all(style: BorderStyle.none),
      backgroundColor: ColorConstants.instance.backgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(context),
            buildMenuItems(context,viewModel)
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
        color: ColorConstants.instance.drawerTopColor,
          //borderRadius: BorderRadius.vertical(bottom: Radius.circular(20),top: Radius.zero)
      ),
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(UserModel.instance.name.toUpperCase(), style: const TextStyle(fontSize: 20)),
            Text(UserModel.instance.email)
          ],
        ),
      ),

    );
  }

  Widget buildMenuItems(BuildContext context,navigationDrawerViewModel viewModel) {
    return Wrap(
      runSpacing: 16,
      children: [
        menuListTile(
            context: context,
            viewModel: viewModel,
            path: NavigationConstants.CREATEORDER,
            titleText: "SİPARİŞ OLUŞTUR",
            icon: Icons.add,
        ),
        menuListTile(
          context: context,
          viewModel: viewModel,
          path: NavigationConstants.ORDERS,
          titleText: "SİPARİŞLER",
          icon: Icons.list_alt,
        ),
        menuListTile(
          context: context,
          viewModel: viewModel,
          path: NavigationConstants.STOCKADD,
          titleText: "STOK",
          icon: Icons.food_bank,
        ),
        menuListTile(
          context: context,
          viewModel: viewModel,
          path: NavigationConstants.CONTACTS,
          titleText: "KİŞİLER",
          icon: Icons.person,
        ),
        menuListTile(
          context: context,
          viewModel: viewModel,
          path: NavigationConstants.STATISTICS,
          titleText: "İSTATİSTİKLER",
          icon: Icons.pie_chart_outline,
        ),
          menuListTile(
            context: context,
            viewModel: viewModel,
            path: NavigationConstants.ADMINPANELMENU,
            titleText: "AYARLAR",
            icon: Icons.settings,
          ),
        const Divider(height: 5,),
        ListTile(
          leading: const Icon(Icons.exit_to_app_outlined, size: 30,),
          title: const Text("ÇIKIŞ", style: TextStyle(fontSize: 18)),
          onTap: () async {
            AuthModel.instance.logOut();
            //Navigator.pop(context);
            // viewModel.navigation
            //     .navigateToPage(path: NavigationConstants.LOGIN);
          },
        ),
      ],
    );
  }

  ListTile menuListTile(
      {
        required BuildContext context,
        required navigationDrawerViewModel viewModel,
        required String path,
        required String titleText,
        required IconData icon,
      }) {
    return ListTile(
        leading: Icon(icon, size: 30,),
        title: Text(titleText, style: TextStyle(fontSize: 18)),
        onTap: () async{
          if(!kIsWeb){
            Navigator.pop(context);
          }
          //Navigator.pop(context);
          if(!context.isWideScreen&&kIsWeb){
            Future.delayed(Duration.zero, () {
              Navigator.pop(context);
            });
          }
          if(!kIsWeb){
            await Future.delayed(Duration(milliseconds: 120));
            viewModel.navigation.navigateToPage(
                path: path);
          }else{
            await Future.delayed(Duration.zero, () {
              viewModel.navigation.pushReplacementNamed(
                  path: path);
            });
          }


        },
      );
  }
}

class navigationDrawerViewModel extends BaseViewModel{
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