import 'package:siparis_takip_demo/core/constants/size_constants.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/extensions/validation/form_validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/base/base_view/base_view.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/text_theme.dart';
import '../viewmodel/register_viewmodel.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<RegisterViewModel>(
      viewModel: RegisterViewModel(),
      onModelReady: (model) async {
        model.setContext(context);
        await model.init();
      },
      onPageBuilder: (context, viewModel, child) => Scaffold(
        backgroundColor: ColorConstants.instance.backgroundColor,
        body: buildBody(viewModel, context),
      ),
    );
  }

  Widget buildBody(RegisterViewModel viewModel, BuildContext context) {
    return Center(
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
                    padding: EdgeInsets.only(
                        top: context.dynamicHeight(0.09),
                        bottom: context.dynamicHeight(0.04)),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Kayıt Ol",
                          style: CustomTextStyle.loginGiris,
                        )),
                  ),

                  ///Kullanıcı adı input
                  label(context, "Kullanıcı Adı/Username"),
                  TextInput(viewModel, context, viewModel.nameController, false),
                  SizedBox(
                    height: context.dynamicHeight(0.02),
                  ),
                  ///Email adresi
                  label(context, "E-Mail Adresi"),
                  TextInput(viewModel, context, viewModel.emailController, false),
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
                  Padding(
                    padding: EdgeInsets.only(bottom: context.dynamicHeight(0.05)),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          await viewModel.register(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                          backgroundColor: ColorConstants.instance.buttonColor,
                        ),
                        child: viewModel.isLoading
                            ? CircularProgressIndicator()
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
    );
  }

  TextFormField TextInput(RegisterViewModel viewModel, BuildContext context,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 20),
        border: OutlineInputBorder(
            borderSide: BorderSide(width: 1),
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
