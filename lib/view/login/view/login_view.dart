import 'package:siparis_takip_demo/core/constants/navigation_constant.dart';
import 'package:siparis_takip_demo/core/constants/size_constants.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/extensions/validation/form_validation.dart';
import 'package:siparis_takip_demo/core/init/navigation/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_view/base_view.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/text_theme.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewModel: LoginViewModel(),
      onModelReady: (model) async {
        model.setContext(context);
        await model.init();
      },
      onPageBuilder: (context, viewModel, child) => Scaffold(
        key: viewModel.scaffoldKey,
        body: buildBody(viewModel, context),
        backgroundColor: ColorConstants.instance.backgroundColor,
      ),
    );
  }

  Widget buildBody(LoginViewModel viewModel, BuildContext context) {
    return Center(
      child: Container(
        color: context.isWideScreen? Colors.white:null,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: SizeConstant.instance!.wideScreenWidth),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.1)),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: context.dynamicHeight(0.13),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.dynamicWidth(0.2)),
                      child: const Text("LOGO"),
                    ),
                    SizedBox(
                      height: context.dynamicHeight(0.02),
                    ),
                    Text(
                      "siparis_takip_demo",
                      style: CustomTextStyle.loginHeadline,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: context.dynamicHeight(0.09),
                          bottom: context.dynamicHeight(0.04)),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Giriş",
                            style: CustomTextStyle.loginGiris,
                          )),
                    ),

                    ///Kullanıcı adı input
                    label(context, "Kullanıcı Adı/Username"),
                    TextInput(viewModel, context, viewModel.nameController, false),
                    SizedBox(
                      height: context.dynamicHeight(0.02),
                    ),

                    ///şifre input
                    label(context, "Şifre/Password"),
                    TextInput(
                        viewModel, context, viewModel.passwordController, true),
                    SizedBox(
                      height: context.dynamicHeight(0.10),
                    ),

                    ///Giriş butonu
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await viewModel.login(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                          backgroundColor: ColorConstants.instance.buttonColor,
                        ),
                        child: viewModel.isWaiting
                            ? const CircularProgressIndicator()
                            : Text(
                                "GİRİŞ YAP",
                                style: CustomTextStyle.buttonTextStyle,
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          const Expanded(child: Divider(thickness: 1,)),
                          Text(" ya da ",style: TextStyle(color: ColorConstants.instance.softTextColor),),
                          const Expanded(child: Divider(thickness: 1,)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: context.dynamicHeight(0.05)),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            NavigationService.instance.navigateToPage(path: NavigationConstants.REGISTER);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            elevation: 0,
                            backgroundColor: ColorConstants.instance.buttonColor,
                          ),
                          child: viewModel.isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                            "KAYIT OL",
                            style: CustomTextStyle.buttonTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField TextInput(LoginViewModel viewModel, BuildContext context,
      TextEditingController controller, bool obsecure,
      [String? message]) {
    return TextFormField(
      controller: controller,
      obscureText: obsecure,
      textAlign: TextAlign.start,
      validator: (value) {
        return obsecure
            ? value?.emptyIs(value)
            : value?.validateNameAndSurname(value);
      },
      style: CustomTextStyle.textFieldStyle,
      decoration: InputDecoration(
        hintStyle: CustomTextStyle.textFieldHintStyle,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        border: OutlineInputBorder(
            borderSide: const BorderSide(width: 1),
            borderRadius: BorderRadius.circular(30)),
        filled: false,
      ),
    );
  }

  Padding label(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(
          left: 10,
          bottom: context.dynamicHeight(0.01)),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: CustomTextStyle.loginLabel,
          )),
    );
  }
}
