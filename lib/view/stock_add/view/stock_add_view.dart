import 'package:siparis_takip_demo/core/constants/color_constants.dart';
import 'package:siparis_takip_demo/core/constants/size_constants.dart';
import 'package:siparis_takip_demo/core/constants/text_constants.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/utils/drawers/navigation_drawer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/base/base_view/base_view.dart';
import '../viewmodel/stock_add_viewmodel.dart';

class StockAddView extends StatelessWidget {
  const StockAddView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<StockAddViewModel>(
      viewModel: StockAddViewModel(),
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
                    IconButton(
                        onPressed:viewModel.isWaiting?null: () => viewModel.reloadData(),
                        icon: const Icon(
                          Icons.replay,
                        ))
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

  Widget buildBody(StockAddViewModel viewModel, BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SizeConstant.instance!.wideScreenWidth),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: context.dynamicWidth(0.04)),
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TeslimatSubeRow(viewModel: viewModel),
                    RowDivider(),
                    CesitRow(viewModel: viewModel),

                  ],
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstants.instance.buttonColor
                            ),
                            onPressed:viewModel.isWaitingButton? null:() {
                              viewModel.saveStock();
                            },
                            child:viewModel.isWaitingButton? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("KAYDEDİLİYOR..."),
                                const CircularProgressIndicator(),
                              ],
                            ):const Text("KAYDET"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Divider RowDivider() {
    return Divider(
      height: 20,
      color: Colors.grey.shade500,
    );
  }
}
class TeslimatSubeRow extends StatelessWidget {
  TeslimatSubeRow({
    required this.viewModel,
    super.key,
  });
  StockAddViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "TESLİMAT ŞUBESİ",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2(
                buttonDecoration: BoxDecoration(
                  color: ColorConstants.instance.textFieldBackgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  border: Border.all(
                    color: ColorConstants.instance.textFieldBorderColor,
                  ),
                ),
                isExpanded: true,
                items: viewModel.subeDropDownItems,
                value: viewModel.subeDropDownValue,
                onChanged: (value) {
                  viewModel.dropDownChanged(value);
                },
                iconSize: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}class CesitRow extends StatelessWidget {
  CesitRow({
    required this.viewModel,
    super.key,
  });
  StockAddViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.dynamicHeight(1)-276,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("ÇEŞİT", style: TextStyle(fontSize: 20)),
              Row(
                children: [
                  const Text("Kalan stok",style: TextStyle(fontSize: 16),),
                  Switch(
                      value: viewModel.kalanStokSwitchValue,
                      onChanged: (value) {
                        viewModel.changeKalanStokSwitchValue(value);
                      },
                  ),
                ],
              )
            ],
          ),
          viewModel.isWaiting?const Center(child: CircularProgressIndicator()) : Expanded(
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: viewModel.listSiparisler.length,
              itemBuilder: (BuildContext context, int index) {
                // viewModel.indexEbat=index%3;
                // viewModel.indexEbat==0?viewModel.indexCesit++:null;
                return listRow(index);

              },
              separatorBuilder: (BuildContext context, int index)  { return const Divider(thickness: 1,height: 10,); },
            ),
          ),
        ],
      ),
    );
  }

  Row listRow(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(viewModel.generateListText(index),style: const TextStyle(fontSize: 18,),),
        // Text("${CustomText.cesitString[viewModel.listSiparisler[index]["cesit"]]} ${CustomText.ebatString[viewModel.listSiparisler[index]["ebat"]]}",style: TextStyle(fontSize: 18,),),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(!viewModel.kalanStokSwitchValue)...[
              Text("${viewModel.listSiparisler[index]["siparis"]} / ",style: const TextStyle(fontSize: 18),),
            ]
            else...[
              Text("${viewModel.listSiparisler[index]["stok"]-viewModel.listSiparisler[index]["siparis"]} / ",style: const TextStyle(fontSize: 18),),
            ],
            IntrinsicWidth(
              child: TextFormField(
                keyboardType: TextInputType.number,

                style: const TextStyle(),
                decoration: const InputDecoration(
                  isDense: true
                ),
                controller: viewModel.controllers[index],
              ),
            )
          ],
        )
      ],
    );
  }
}