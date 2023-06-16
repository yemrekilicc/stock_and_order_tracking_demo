import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/base/base_view/base_view.dart';
import '../../../core/constants/color_constants.dart';
import '../viewmodel/splash_viewmodel.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashViewModel>(
      viewModel: Provider.of<SplashViewModel>(context, listen: false),
      onModelReady: (model) async {
        model.setContext(context);
        await model.init();
      },
      onPageBuilder: (context, viewModel, child) => Scaffold(
        backgroundColor: ColorConstants.instance.backgroundColor,
        body: SizedBox(
          height: context.dynamicHeight(1),
          width: context.dynamicWidth(1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.1)),
                child: const Center(child: Text("baklava")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
