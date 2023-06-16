import 'package:siparis_takip_demo/core/constants/color_constants.dart';
import 'package:siparis_takip_demo/core/constants/size_constants.dart';
import 'package:siparis_takip_demo/core/constants/text_constants.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/init/firebase/query.dart';
import 'package:siparis_takip_demo/core/utils/drawers/navigation_drawer.dart';
import 'package:siparis_takip_demo/model/musteriler_model.dart';
import 'package:siparis_takip_demo/model/siparisler_model.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../core/base/base_view/base_view.dart';
import '../../../core/constants/navigation_constant.dart';
import '../viewmodel/create_order_viewmodel.dart';

class CreateOrderView extends StatelessWidget {
  const CreateOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Siparisler? siparis =
        ModalRoute.of(context)?.settings.arguments as Siparisler?;
    return BaseView<CreateOrderViewModel>(
      viewModel: CreateOrderViewModel(),//Provider.of<CreateOrderViewModel>(context, listen: false),
      onModelReady: (model) async {
        model.setContext(context);
        await model.init(siparis: siparis);
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
                  iconTheme: const IconThemeData(color: Colors.black),
                  // shape: const RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.vertical(
                  //     bottom: Radius.circular(10),
                  //   ),
                  // ),
                  elevation: 0,
                ),
                key: viewModel.scaffoldKey,
                backgroundColor: ColorConstants.instance.backgroundColor,
                drawer: viewModel.isUpdate||context.isWideScreen ? null : const navigationDrawer(),
                body: buildBody(viewModel, context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody(CreateOrderViewModel viewModel, BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: SizeConstant.instance!.wideScreenWidth),
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: context.dynamicWidth(0.04),
            left: context.dynamicWidth(0.04),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("İSİM", style: TextStyle(fontSize: 18)),
                    IsimRow(viewModel: viewModel),
                    RowDivider(),
                    if(viewModel.isLoading)...[
                      CircularProgressIndicator()
                    ]else...[
                      for(int i=0;i<CustomText.tableHierarchy.length;i++)...[
                        NewTableRow(
                          key: UniqueKey(),
                          viewModel: viewModel,
                          siparisCounter: i==1,
                          kalanSiparis: i==2,
                          tableName: CustomText.tableHierarchy[i]["tableName"],
                          tableValueName: CustomText.tableHierarchy[i]["tableValueName"],
                        ),
                        RowDivider(),
                      ],
                    ],

                    // TeslimatSubeRow(viewModel: viewModel),
                    // RowDivider(),
                    // CesitRow(viewModel: viewModel),
                    // RowDivider(),
                    // EbatRow(viewModel: viewModel),
                    // RowDivider(),
                    NotRow(viewModel: viewModel),
                    if (!viewModel.isUpdate) ...[
                      RowDivider(),
                      SiparislerList(viewModel: viewModel),
                    ],
                    SizedBox(
                      height: context.dynamicHeight(0.03),
                    ),
                  ],
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (viewModel.isUpdate) ...[
                        GuncelleButton(viewModel: viewModel)
                      ] else ...[
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: KaydetButton(viewModel: viewModel)),
                              const SizedBox(width: 5),
                              Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: EkleListButton(viewModel: viewModel)),
                            ],
                          ),
                        )
                      ],
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

class IsimRow extends StatelessWidget {
  IsimRow({
    required this.viewModel,
    super.key,
  });
  CreateOrderViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          flex: 3,
          child: StreamBuilder<List<Musteriler>>(
              stream: Querys.instance.readMusterilerStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData && viewModel.isUpdate) {
                  // viewModel.selectMusteri(
                  //     viewModel.selectedName, snapshot.data!);
                }
                if (snapshot.hasData) {
                  debugPrint("data");
                }
                return TypeAheadFormField<String?>(
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    constraints: BoxConstraints(
                      maxHeight: context.dynamicHeight(0.3),
                    ),
                  ),
                  hideOnEmpty: true,
                  textFieldConfiguration: TextFieldConfiguration(
                    style: const TextStyle(fontSize: 18),
                    enabled: snapshot.hasData,
                    controller: viewModel.controllerName,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 14,
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorConstants.instance.buttonColor,
                        ),
                      ),
                    ),
                  ),
                  onSuggestionSelected: (suggestion) {
                    viewModel.selectMusteri(suggestion!, snapshot.data!);
                    // viewModel.selectedMusteri = snapshot.data!.firstWhere(
                    //     (element) => element.adi!.contains(suggestion!));
                    // viewModel.controllerName.text = suggestion!;
                  },
                  itemBuilder: (context, itemData) {
                    return ListTile(
                      title: Text(itemData ??= ""),
                    );
                  },
                  suggestionsCallback: (pattern) {
                    return List.of(snapshot.data!.map((e) => e.adi).toList())
                        .where((isim) {
                      final isimLower = isim.toLowerCase();
                      final patternLower = pattern.toLowerCase();
                      return isimLower.contains(patternLower);
                    });
                  },
                );
              }),
        ),
        const SizedBox(width: 5),
        Flexible(
          flex: 2,
          child: Row(
            children: [
              Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: EkleButton(viewModel: viewModel)),
              const SizedBox(width: 5),
              Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: HizliEkleButton(viewModel: viewModel)),
            ],
          ),
        )
      ],
    );
  }
}

class EkleListButton extends StatelessWidget {
  EkleListButton({
    required this.viewModel,
    super.key,
  });
  CreateOrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.dynamicWidth(0.4),
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.instance.buttonColor),
          onPressed: () {
            if (viewModel.remainingStock! - viewModel.adetCounter < 0) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text("Eklenen adet sayısı kalan stoktan fazla olamaz")));
            } else if (viewModel.selectedMusteri == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Kişi seçilmedi")));
            } else {
              viewModel.addSiparis();
            }
          },
          child: const Text(
            "EKLE",
            style: TextStyle(fontSize: 18, color: Colors.white),
          )),
    );
  }
}

class GuncelleButton extends StatelessWidget {
  GuncelleButton({
    required this.viewModel,
    super.key,
  });
  CreateOrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstants.instance.buttonColor),
            onPressed: () {
              if (viewModel.remainingStock! - viewModel.adetCounter < 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text("Eklenen adet sayısı kalan stoktan fazla olamaz"),
                  ),
                );
              } else {
                viewModel.updateSiparis(context);
              }
            },
            child: const Text(
              "GÜNCELLE",
              style: TextStyle(fontSize: 18, color: Colors.white),
            )),
      ),
    );
  }
}

class KaydetButton extends StatelessWidget {
  KaydetButton({
    required this.viewModel,
    super.key,
  });
  CreateOrderViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.dynamicWidth(0.4),
      height: 50,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.instance.buttonColor),
          onPressed: () async {
            if (viewModel.selectedMusteri != null) {
              if (viewModel.siparisler.isNotEmpty) {
                await viewModel
                    .saveSiparisler()
                    .then((_) => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("OK"))
                            ],
                            content: const Text("SİPARİŞLER KAYDEDİLDİ"),
                          ),
                        ))
                    .then((value) => viewModel.navigation.pushReplacementNamed(
                          path: NavigationConstants.CREATEORDER,
                        ))
                    .catchError((error) => ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("HATA: $error"))));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sipariş eklenmedi")));
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Kişi seçilmedi")));
            }
          },
          child: const Text(
            "KAYDET",
            style: TextStyle(fontSize: 18),
          )),
    );
  }
}

class SiparislerList extends StatelessWidget {
  SiparislerList({
    required this.viewModel,
    super.key,
  });
  CreateOrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: context.dynamicHeight(0.2)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SİPARİŞLER",
            style: TextStyle(fontSize: 18),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: viewModel.siparisler.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  dense: true,
                  leading: Text(
                    viewModel.siparisler[index].adet.toString(),
                    style: const TextStyle(fontSize: 15),
                  ),
                  title: Text(
                    viewModel.generateText(index),
                    style: const TextStyle(fontSize: 15),
                  ),
                  subtitle: viewModel.siparisler[index].not == ""
                      ? null
                      : Text(
                          viewModel.siparisler[index].not!,
                          style: const TextStyle(fontSize: 14),
                        ),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    color: Colors.red,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Sipariş silindi")));
                      viewModel.deleteSiparis(index);
                    },
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          )
        ],
      ),
    );
  }
}

class NotRow extends StatelessWidget {
  NotRow({
    required this.viewModel,
    super.key,
  });
  CreateOrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            "NOT",
            style: TextStyle(fontSize: 18),
          ),
        ),
        TextField(
          style: const TextStyle(
            fontSize: 18,
          ),
          controller: viewModel.controllerNot,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            filled: true,
            fillColor: ColorConstants.instance.textFieldBackgroundColor,
            isDense: true,
            contentPadding: const EdgeInsets.all(5),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorConstants.instance.textFieldBorderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorConstants.instance.buttonColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
class NewTableRow extends StatelessWidget {
  NewTableRow({
    required this.viewModel,
    required this.siparisCounter,
    required this.kalanSiparis,
    required this.tableName,
    required this.tableValueName,
    super.key,
  });
  CreateOrderViewModel viewModel;
  bool siparisCounter;
  bool kalanSiparis;
  String tableValueName;
  String tableName;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child:  Text(
                  tableName.toUpperCase(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              DropdownButtonHideUnderline(
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
                  items: viewModel.dropDownItemsMap["${tableValueName}DropDownItems"]!.isEmpty
                      ? [
                    const DropdownMenuItem(
                      value: 0,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ]
                      : viewModel.dropDownItemsMap["${tableValueName}DropDownItems"],
                  value: viewModel.dropDownValueMap["${tableValueName}DropDownValue"],
                  onChanged: (value) {
                    viewModel.updateDropDown(value!,tableValueName);
                  },
                  iconSize: 30,
                ),
              ),
            ],
          ),
        ),
        if(kalanSiparis)...[
          Flexible(
            flex: 2,
            child: SizedBox(
              height: 50,
              child: Align(
                alignment: Alignment.center,
                child: viewModel.remainingStock == null
                    ? const Text("KALAN STOK: ")
                    : (viewModel.remainingStock == 0
                    ? Text(
                  "STOK BULUNMAMAKTADIR",
                  style: TextStyle(
                      fontSize: 16,
                      color: ColorConstants.instance.cancelColor),
                )
                    : FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "KALAN STOK: ${viewModel.remainingStock.toString()}",
                    style: const TextStyle(fontSize: 16),
                  ),
                )),
              ),
            ),
          )
        ],
        if(siparisCounter)...[
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 120,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "ADET",
                      style: TextStyle(fontSize: 18),
                    ),
                    Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      color: ColorConstants.instance.textFieldBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: ColorConstants.instance.textFieldBorderColor,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => viewModel.decAdet(),
                          ),
                          Text(
                            viewModel.adetCounter.toString(),
                            style: const TextStyle(fontSize: 22),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => viewModel.incAdet(),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]
      ],
    );
  }
}
// class TeslimatSubeRow extends StatelessWidget {
//   TeslimatSubeRow({
//     required this.viewModel,
//     super.key,
//   });
//   CreateOrderViewModel viewModel;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(bottom: 10),
//           child: const Text(
//             "TESLİMAT ŞUBESİ",
//             style: TextStyle(fontSize: 18),
//           ),
//         ),
//         SizedBox(
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton2(
//               buttonDecoration: BoxDecoration(
//                 color: ColorConstants.instance.textFieldBackgroundColor,
//                 borderRadius: const BorderRadius.all(
//                   Radius.circular(5),
//                 ),
//                 border: Border.all(
//                   color: ColorConstants.instance.textFieldBorderColor,
//                 ),
//               ),
//               isExpanded: true,
//               items: viewModel.subeDropDownItems.isEmpty
//                   ? [
//                       DropdownMenuItem(
//                         child: Center(child: CircularProgressIndicator()),
//                         value: 0,
//                       ),
//                     ]
//                   : viewModel.subeDropDownItems,
//               value: viewModel.subeDropDownValue,
//               onChanged: (value) {
//                 viewModel.updateDropDownSube(value!);
//               },
//               iconSize: 30,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class EbatRow extends StatelessWidget {
//   EbatRow({
//     required this.viewModel,
//     super.key,
//   });
//   CreateOrderViewModel viewModel;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: const Text(
//                 "EBAT",
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//             SizedBox(
//               width: context.dynamicWidth(0.5),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton2(
//                   buttonDecoration: BoxDecoration(
//                     color: ColorConstants.instance.textFieldBackgroundColor,
//                     borderRadius: const BorderRadius.all(
//                       Radius.circular(5),
//                     ),
//                     border: Border.all(
//                       color: ColorConstants.instance.textFieldBorderColor,
//                     ),
//                   ),
//                   isExpanded: true,
//                   items: viewModel.ebatDropDownItems.isEmpty
//                       ? [
//                           DropdownMenuItem(
//                             child: Center(child: CircularProgressIndicator()),
//                             value: 0,
//                           ),
//                         ]
//                       : viewModel.ebatDropDownItems,
//                   value: viewModel.ebatDropDownValue,
//                   onChanged: (value) {
//                     viewModel.updateDropDownEbat(value!);
//                   },
//                   iconSize: 30,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         Expanded(
//             child: Container(
//           height: 50,
//           child: Align(
//             alignment: Alignment.center,
//             child: viewModel.remainingStock == null
//                 ? Text("KALAN STOK: ")
//                 : (viewModel.remainingStock == 0
//                     ? Text(
//                         "STOK BULUNMAMAKTADIR",
//                         style: TextStyle(
//                             fontSize: 16,
//                             color: ColorConstants.instance.cancelColor),
//                       )
//                     : FittedBox(
//                         fit: BoxFit.fitWidth,
//                         child: Text(
//                           "KALAN STOK: ${viewModel.remainingStock.toString()}",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                       )),
//           ),
//         ))
//       ],
//     );
//   }
// }
//
// class CesitRow extends StatelessWidget {
//   CesitRow({
//     required this.viewModel,
//     super.key,
//   });
//   CreateOrderViewModel viewModel;
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: const Text("ÇEŞİT", style: TextStyle(fontSize: 18)),
//                 ),
//                 SizedBox(
//                   width: context.dynamicWidth(0.5),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton2(
//                       buttonDecoration: BoxDecoration(
//                         color: ColorConstants.instance.textFieldBackgroundColor,
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(5),
//                         ),
//                         border: Border.all(
//                           color: ColorConstants.instance.textFieldBorderColor,
//                         ),
//                       ),
//                       dropdownDecoration: BoxDecoration(),
//                       isExpanded: true,
//                       items: viewModel.cesitDropDownItems.isEmpty
//                           ? [
//                               DropdownMenuItem(
//                                 child:
//                                     Center(child: CircularProgressIndicator()),
//                                 value: 0,
//                               ),
//                             ]
//                           : viewModel.cesitDropDownItems,
//                       value: viewModel.cesitDropDownValue,
//                       onChanged: (value) {
//                         viewModel.updateDropDownCesit(value!);
//                       },
//                       iconSize: 30,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const Expanded(child: SizedBox()),
//             Column(
//               mainAxisSize: MainAxisSize.max,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   "ADET",
//                   style: TextStyle(fontSize: 18),
//                 ),
//                 Card(
//                   elevation: 0,
//                   margin: EdgeInsets.zero,
//                   color: ColorConstants.instance.textFieldBackgroundColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     side: BorderSide(
//                       color: ColorConstants.instance.textFieldBorderColor,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.remove),
//                         onPressed: () => viewModel.decAdet(),
//                       ),
//                       Text(
//                         viewModel.adetCounter.toString(),
//                         style: const TextStyle(fontSize: 22),
//                       ),
//                       IconButton(
//                         icon: const Icon(Icons.add),
//                         onPressed: () => viewModel.incAdet(),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//             const Expanded(child: SizedBox())
//           ],
//         ),
//       ),
//     );
//   }
// }

class HizliEkleButton extends StatelessWidget {
  HizliEkleButton({
    required this.viewModel,
    super.key,
  });
  CreateOrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      //width: context.dynamicWidth(0.2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.zero,
          backgroundColor: ColorConstants.instance.buttonColor,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: viewModel.isUpdate
            ? null
            : (viewModel.selectedMusteri != null
                ? null
                : viewModel.fastAddEnable
                    ? () async {
                        await viewModel.createOrder(context);
                      }
                    : null),
        child: const FittedBox(fit: BoxFit.fitWidth, child: Text("HIZLI EKLE")),
      ),
    );
  }
}

class EkleButton extends StatelessWidget {
  EkleButton({
    required this.viewModel,
    super.key,
  });
  CreateOrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      //width: context.dynamicWidth(0.15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.zero,
          backgroundColor: ColorConstants.instance.buttonColor,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: viewModel.isUpdate
            ? null
            : (viewModel.selectedMusteri != null
                ? () {
                    viewModel.removeSelectedMusteri();
                  }
                : () {
                    viewModel.navigation.navigateToPage(
                      path: NavigationConstants.ADDCONTACT,
                      data: {
                        "musteri": Musteriler(
                            adi: viewModel.controllerName.value.text),
                        "isUpdate": false
                      },
                    );
                  }),
        child: viewModel.selectedMusteri != null
            ? Icon(Icons.cancel_outlined,
                color: ColorConstants.instance.cancelColor)
            : const Text("EKLE"),
      ),
    );
  }
}
