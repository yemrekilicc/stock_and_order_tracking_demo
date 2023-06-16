import 'package:siparis_takip_demo/core/constants/color_constants.dart';
import 'package:siparis_takip_demo/core/constants/navigation_constant.dart';
import 'package:siparis_takip_demo/core/constants/size_constants.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/utils/drawers/navigation_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/base/base_view/base_view.dart';
import '../viewmodel/admin_panel_menu_viewmodel.dart';

class AdminPanelMenuView extends StatelessWidget {
  const AdminPanelMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AdminPanelMenuViewModel>(
      viewModel: AdminPanelMenuViewModel(),
      onModelReady: (model) async {
        model.setContext(context);
        await model.init();
      },
      onPageBuilder: (context, viewModel, child) => SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if(context.isWideScreen)
              ...[
                const navigationDrawer()
              ],
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: !context.isWideScreen,
                  backgroundColor: ColorConstants.instance.drawerTopColor,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.black),
                  actions: [
                  ],
                ),
                key: viewModel.scaffoldKey,

                backgroundColor: ColorConstants.instance.backgroundColor,
                drawer:context.isWideScreen? null:const navigationDrawer(),
                body: buildBody(viewModel, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody(AdminPanelMenuViewModel viewModel, BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SizeConstant.instance!.wideScreenWidth),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                viewModel.navigation
                    .navigateToPage(path: NavigationConstants.ADMINPANEL,data: "delete");
              },
              child: const ListTile(
                title: Text("TABLOLARDAN ÖĞE SİL"),

              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                viewModel.navigation
                    .navigateToPage(path: NavigationConstants.ADMINPANEL,data: "update");
              },
              child: const ListTile(
                title: Text("TABLOLARDAN ÖĞE DÜZENLE"),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                viewModel.navigation
                    .navigateToPage(path: NavigationConstants.ADMINPANEL,data: "add");
              },
              child: const ListTile(
                title: Text("TABLOLARA ÖĞE EKLE"),
              ),
            ),
            const Divider(),

          ],
        ),
      ),
    );

  }
}
