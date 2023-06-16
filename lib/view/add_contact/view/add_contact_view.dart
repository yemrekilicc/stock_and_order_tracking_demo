
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siparis_takip_demo/core/constants/color_constants.dart';
import 'package:siparis_takip_demo/core/constants/regexp_constants.dart';
import 'package:siparis_takip_demo/core/constants/size_constants.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/utils/drawers/navigation_drawer.dart';

import '../../../core/base/base_view/base_view.dart';
import '../viewmodel/add_contact_viewmodel.dart';

class AddContactView extends StatelessWidget {
  const AddContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    return BaseView<AddContactViewModel>(
      viewModel: AddContactViewModel(),
      onModelReady: (model) async {
        model.setContext(context);
        await model.init(musteri: user);
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

  Widget buildBody(AddContactViewModel viewModel, BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SizeConstant.instance!.wideScreenWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.04)),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text("İSİM", style: TextStyle(fontSize: 20)),
                    ),
                    TextField(
                        style: const TextStyle(fontSize: 18),
                        controller: viewModel.isimController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                ColorConstants.instance.textFieldBackgroundColor,
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstants
                                        .instance.textFieldBorderColor)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstants.instance.buttonColor)),
                            contentPadding: const EdgeInsets.all(10))),
                    Divider(
                      height: 20,
                      color: Colors.grey.shade500,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text("TELEFON", style: TextStyle(fontSize: 20)),
                    ),
                    TextField(
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExpConstans.instance!.phoneExp),
                        ],
                        style: const TextStyle(fontSize: 18),
                        controller: viewModel.telefonController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                ColorConstants.instance.textFieldBackgroundColor,
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstants.instance.buttonColor)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: ColorConstants
                                        .instance.textFieldBorderColor)),
                            contentPadding: const EdgeInsets.all(10))),
                    Divider(
                      height: 20,
                      color: Colors.grey.shade500,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text("ADRES", style: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(
                      height: context.dynamicHeight(0.15),
                      child: TextField(
                          style: const TextStyle(fontSize: 18),
                          controller: viewModel.adresController,
                          keyboardType: TextInputType.multiline,
                          textAlignVertical: TextAlignVertical.top,
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: ColorConstants
                                  .instance.textFieldBackgroundColor,
                              isDense: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          ColorConstants.instance.buttonColor)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorConstants
                                          .instance.textFieldBorderColor)),
                              contentPadding: const EdgeInsets.all(10))),
                    ),
                    Divider(
                      height: 20,
                      color: Colors.grey.shade500,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text("NOT", style: TextStyle(fontSize: 20)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: SizedBox(
                        height: context.dynamicHeight(0.15),
                        child: TextField(
                            style: const TextStyle(fontSize: 18),
                            controller: viewModel.notController,
                            keyboardType: TextInputType.multiline,
                            textAlignVertical: TextAlignVertical.top,
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorConstants
                                    .instance.textFieldBackgroundColor,
                                isDense: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            ColorConstants.instance.buttonColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: ColorConstants
                                            .instance.textFieldBorderColor)),
                                contentPadding: const EdgeInsets.all(10))),
                      ),
                    ),
                  ],
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        //width: context.dynamicWidth(0.92),
                        height: 70,
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (viewModel.isimController.value.text != "") {
                              if (viewModel.isUpdate) {
                                await viewModel
                                    .updateContact()
                                    .then(
                                      (_) => showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("OK"))
                                          ],
                                          content: const Text("KİŞİ GÜNCELLENDİ"),
                                        ),
                                      ),
                                    )
                                    .then((value) => viewModel.navigation.popPage())
                                    .catchError(
                                      (error) => ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text("hata $error"),
                                        ),
                                      ),
                                    );
                              }
                              else{
                                await viewModel
                                    .addContact()
                                    .then(
                                      (_) => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("OK"))
                                      ],
                                      content: const Text("KİŞİ KAYDEDİLDİ"),
                                    ),
                                  ),
                                )
                                    .then((value) => viewModel.navigation.popPage())
                                    .catchError(
                                      (error) =>
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("hata $error"),
                                        ),
                                      ),
                                );
                              }
                            }
                          },
                          child: Text(
                            viewModel.isUpdate ? "KİŞİ GÜNCELLE":"KİŞİ EKLE" ,
                            style: const TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorConstants.instance.buttonColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
