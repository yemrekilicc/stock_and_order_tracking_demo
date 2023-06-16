import 'package:siparis_takip_demo/core/constants/color_constants.dart';
import 'package:siparis_takip_demo/core/constants/navigation_constant.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/utils/drawers/navigation_drawer.dart';
import 'package:siparis_takip_demo/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_view/base_view.dart';
import '../viewmodel/main_screen_viewmodel.dart';

class MainScreenView extends StatelessWidget {
  const MainScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<MainScreenViewModel>(
      viewModel: MainScreenViewModel(),
      onModelReady: (model) async {
        model.setContext(context);
        await model.init();
      },
      onPageBuilder: (context, viewModel, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.vertical(
            //     bottom: Radius.circular(10),
            //   ),
            // ),
            elevation: 0,
          ),
          key: viewModel.scaffoldKey,
          //appBar: AppBar(backgroundColor: Colors.transparent,elevation: 0),
          backgroundColor: ColorConstants.instance.backgroundColor,
          body: buildBody(viewModel, context),
          drawer:context.isWideScreen? null:const navigationDrawer(),
        ),
      ),
    );
  }

  Widget buildBody(MainScreenViewModel viewModel, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              menuItem(
                  onTap: () {
                    viewModel.navigation.navigateToPage(
                        path: NavigationConstants.CREATEORDER);
                  },
                  title: "SİPARİŞ OLUŞTUR",
                  icon: Icons.add),
              menuItem(
                  onTap: () {
                    viewModel.navigation
                        .navigateToPage(path: NavigationConstants.ORDERS);
                  },
                  title: "SİPARİŞLER",
                  icon: Icons.list_alt),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              menuItem(
                  onTap: () {
                    viewModel.navigation
                        .navigateToPage(path: NavigationConstants.STATISTICS);
                  },
                  title: "İSTATİSTİKLER",
                  icon: Icons.pie_chart_outline),
              menuItem(
                  onTap: () {
                    viewModel.navigation
                        .navigateToPage(path: NavigationConstants.CONTACTS);
                  },
                  title: "KİŞİLER",
                  icon: Icons.person),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              menuItem(
                  onTap: () {
                    viewModel.navigation
                        .navigateToPage(path: NavigationConstants.STOCKADD);
                  },
                  title: "STOK",
                  icon: Icons.food_bank),
                menuItem(
                  onTap: (){
                    viewModel.navigation
                        .navigateToPage(path: NavigationConstants.ADMINPANELMENU);
                  },
                  title: "AYARLAR",
                  icon: Icons.settings),
            ],
          ),
        ],
      ),
    );
  }
}



class menuItem extends StatelessWidget {
  menuItem(
      {Key? key, required this.onTap, required this.title, required this.icon})
      : super(key: key);

  Function() onTap;
  String title;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Text(title),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: ColorConstants.instance.buttonColor),
            constraints: const BoxConstraints(
                minWidth: 100, maxWidth: 200, minHeight: 100, maxHeight: 200),
            child: Icon(icon, size: context.dynamicWidth(0.2)),
          ),
        ],
      ),
    );
  }
}
