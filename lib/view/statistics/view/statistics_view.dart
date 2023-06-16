import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siparis_takip_demo/core/constants/color_constants.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/utils/drawers/navigation_drawer.dart';

import '../../../core/base/base_view/base_view.dart';
import '../viewmodel/statistics_viewmodel.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<StatisticsViewModel>(
      viewModel: StatisticsViewModel(),
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

  Widget buildBody(StatisticsViewModel viewModel, BuildContext context) {
    return Center(
      child: Text("COMING SOON..."),
    );

  }
}
