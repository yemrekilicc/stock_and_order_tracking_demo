import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:siparis_takip_demo/core/constants/color_constants.dart';
import 'package:siparis_takip_demo/core/constants/size_constants.dart';
import 'package:siparis_takip_demo/core/constants/text_constants.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/init/firebase/query.dart';
import 'package:siparis_takip_demo/core/utils/drawers/filter_order_drawer.dart';
import 'package:siparis_takip_demo/core/utils/drawers/navigation_drawer.dart';
import 'package:siparis_takip_demo/model/siparisler_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/base/base_view/base_view.dart';
import '../viewmodel/orders_viewmodel.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<OrdersViewModel>(
      viewModel: OrdersViewModel(),
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
                  toolbarHeight: context.isWideScreen?80:null,
                  title: context.isWideScreen?Align(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: SizeConstant.instance!.wideScreenWidth,
                          minWidth: 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: const TextStyle(fontSize: 20),
                              controller: viewModel.searchController,
                              onSubmitted: (value) {
                                viewModel.searchSortAndFilter();

                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                filled: true,
                                fillColor: ColorConstants
                                    .instance.textFieldBackgroundColor,
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: viewModel.searchController.text!=""?IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    viewModel.searchController.text="";
                                    viewModel.searchSortAndFilter();
                                  },
                                ):null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          if(context.isWideScreen==true&&context.isVeryWideScreen==false)...[
                            IconButton(
                              onPressed: () {
                                viewModel.scaffoldKey.currentState!.openEndDrawer();
                              },
                              icon: const Icon(
                                Icons.sort,
                                color: Colors.white,
                                size: 30,
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  ):null,
                  automaticallyImplyLeading: !context.isWideScreen,
                  backgroundColor: ColorConstants.instance.drawerTopColor,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [
                    // IconButton(
                    //     onPressed: () => //viewModel.reloadMusterilerveSiparisler()
                    //     ,
                    //     icon: const Icon(
                    //       Icons.replay,
                    //     ))
                  ],
                ),
                key: viewModel.scaffoldKey,
                backgroundColor: ColorConstants.instance.backgroundColor,
                drawer:context.isWideScreen? null:const navigationDrawer(),
                body: buildBody(viewModel, context),
                endDrawer: context.isWideScreen==true&&context.isVeryWideScreen==false?filterOrderDrawer(viewModel: viewModel):null,
              ),
            ),
            if(context.isVeryWideScreen)
              ...[
                filterOrderDrawer(viewModel: viewModel)
              ],
          ],
        ),
      ),
    );
  }

  Widget buildBody(OrdersViewModel viewModel, BuildContext context) {
    return Center(
          child: Column(
            children: [
              if(!context.isWideScreen)...[
                Container(
                decoration: BoxDecoration(
                  color: ColorConstants.instance.drawerTopColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: context.dynamicWidth(0.04),
                    right: context.dynamicWidth(0.04),
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: SizeConstant.instance!.wideScreenWidth,
                              minWidth: 0),
                          child: TextField(
                            style: const TextStyle(fontSize: 20),
                            controller: viewModel.searchController,
                            onChanged: (input) {
                              viewModel.sortAndFilter();
                            },
                            decoration: InputDecoration(
                              suffixIcon: viewModel.searchController.text!=""?IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  viewModel.searchController.text="";
                                  viewModel.searchSortAndFilter();
                                },
                              ):null,
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: ColorConstants
                                  .instance.textFieldBackgroundColor,
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            backgroundColor:
                            ColorConstants.instance.backgroundColor,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              FocusScope.of(context).unfocus();
                              return DraggableScrollableSheet(
                                initialChildSize: 0.7,
                                maxChildSize: 0.9,
                                expand: false,
                                builder: (BuildContext context,
                                    ScrollController scrollController) {
                                  return BottomSheet(
                                    viewModel: viewModel,
                                    scrollController: scrollController,
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.sort,
                          color: Colors.white,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
              )
              ],
              StreamBuilder(
                stream: Querys.instance.readSiparislerStream() ,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    viewModel.orjList=snapshot.data!;
                    viewModel.setData();
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      );
                  }
                  else if(snapshot.connectionState ==ConnectionState.active){
                    if(snapshot.hasError){
                      return const Text("hata oluştu");
                    }
                    else if(snapshot.hasData){
                          return Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: SizeConstant.instance!.wideScreenWidth,maxHeight: 40),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: Text(
                                          "siparis sayısı : ${viewModel.getSiparisCount()}",
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      // FittedBox(
                                      //   fit: BoxFit.fitWidth,
                                      //   child: Container(
                                      //     padding: const EdgeInsets.symmetric(horizontal: 20),
                                      //     child: Text(viewModel.saat,
                                      //       style: const TextStyle(fontSize: 18),),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: SizeConstant.instance!.wideScreenWidth-100),
                                    child: ListView.builder(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      controller: viewModel.siparislerController,
                                      key: const PageStorageKey<String>('page'),
                                      itemCount: viewModel
                                          .musterilerveSiparislerSuggestion.length,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        return SiparisCard(
                                          viewModel: viewModel,
                                          siparis: viewModel
                                              .musterilerveSiparislerSuggestion[index],
                                          index: index,
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                    }
                    else{
                      return const Text("...");
                    }
                  }else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                },
              )
              // if (snapshot.connectionState == ConnectionState.waiting) ...[
              //   return const Padding(
              //     padding: EdgeInsets.all(8.0),
              //     child: CircularProgressIndicator(),
              //   ),
              // ] else if (snapshot.connectionState ==
              //     ConnectionState.active) ...[
              //   if (snapshot.hasError) ...[
              //     return const Text("hata oluştu")
              //   ] else if (snapshot.hasData) ...[
              //     return ConstrainedBox(
              //       constraints: BoxConstraints(
              //           maxWidth: SizeConstant.instance!.wideScreenWidth),
              //
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Container(
              //             alignment: Alignment.centerLeft,
              //             padding: const EdgeInsets.symmetric(horizontal: 20),
              //             child: Text(
              //               "siparis sayısı : ${viewModel.getSiparisCount()}",
              //               style: const TextStyle(fontSize: 18),
              //             ),
              //           ),
              //           FittedBox(
              //             fit: BoxFit.fitWidth,
              //             child: Container(
              //               padding: const EdgeInsets.symmetric(horizontal: 20),
              //               child: Text(viewModel.saat,
              //                 style: const TextStyle(fontSize: 18),),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       child: ConstrainedBox(
              //         constraints: BoxConstraints(
              //             maxWidth: SizeConstant.instance!.wideScreenWidth-100),
              //         child: ListView.builder(
              //           physics: const AlwaysScrollableScrollPhysics(),
              //           scrollDirection: Axis.vertical,
              //           controller: viewModel.siparislerController,
              //           key: const PageStorageKey<String>('page'),
              //           itemCount: viewModel
              //               .musterilerveSiparislerSuggestion.length,
              //           shrinkWrap: true,
              //           itemBuilder: (BuildContext context, int index) {
              //             return SiparisCard(
              //               viewModel: viewModel,
              //               siparis: viewModel
              //                   .musterilerveSiparislerSuggestion[index],
              //               index: index,
              //             );
              //           },
              //         ),
              //       ),
              //     )
              //   ] else ...[
              //     return const Text("...")
              //   ]
              // ] else ...[
              //   return Text('State: ${snapshot.connectionState}')
              // ]
            ],
          ),
        );
  }
}

class BottomSheet extends StatefulWidget {
  BottomSheet({
    required this.viewModel,
    required this.scrollController,
    super.key,
  });
  ScrollController scrollController;
  OrdersViewModel viewModel;

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
            width: 60,
            child: Divider(
              thickness: 3,
            )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              controller: widget.scrollController,
              children: [
                const Text("SIRALAMA ", style: TextStyle(fontSize: 18)),
                FilterOption(
                  viewModel: widget.viewModel,
                  titleText: "Zamana göre :",
                  optionsText: const ["Yeniden Eskiye", "Eskiden Yeniye"],
                  optionsValue: const [true, false],
                  groupValue: widget.viewModel.isDescending,
                  updateFunction: (value) {
                    setState(() {
                      widget.viewModel.sortAsc(value!);
                    });
                  },
                  crossAxisCount: 2,
                  toggleable: false,
                ),
                const Text(
                  "FİLTRELEME",
                  style: TextStyle(fontSize: 18),
                ),
                FilterOption(
                  viewModel: widget.viewModel,
                  titleText: "Sipariş durumuna göre :",
                  optionsText: const ["Teslim Edilmiş", "Teslim Edilmemiş"],
                  optionsValue: const [1, 0],
                  groupValue: widget.viewModel.isDone,
                  updateFunction: (value) {
                    setState(() {
                      if (value == null) {
                        widget.viewModel.filterDone(-1);
                      } else {
                        widget.viewModel.filterDone(value);
                      }
                    });
                  },
                  crossAxisCount: 2,
                  toggleable: true,
                ),
                for(var element in CustomText.tableHierarchy)...[
                  FilterOption(
                    viewModel: widget.viewModel,
                    titleText: "${element["tableName"]}",
                    optionsText: CustomText.allTablesString[element["tableName"]]!,
                    groupValue: widget.viewModel.filterSelection["selected${element["tableValueName"]}"],
                    updateFunction: (value) {
                      setState(() {
                        if (value == null) {
                          widget.viewModel.filter(-1,element["tableValueName"]);
                        } else {
                          widget.viewModel.filter(value,element["tableValueName"]);
                        }
                      });
                    },
                    crossAxisCount: 2,
                    toggleable: true,
                  ),
                ],
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstants.instance.buttonColor,
                          elevation: 0),
                      onPressed: () {
                        setState(() {
                          widget.viewModel.resetFilters();
                        });
                      },
                      child: const Text(
                        "SIFIRLA",
                        style: TextStyle(fontSize: 16),
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}



class SiparisCard extends StatelessWidget {
  SiparisCard({
    required this.viewModel,
    required this.siparis,
    required this.index,
    super.key,
  });
  OrdersViewModel viewModel;
  Siparisler siparis;
  int index;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: ColorConstants.instance.siparisCardTopColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Flexible(
                      //   fit: FlexFit.loose,
                      //   child: FittedBox(
                      //     fit: BoxFit.fitWidth,
                      //     child: Text(
                      //       viewModel.musterilerveSiparislerSuggestion[index]
                      //           .musteriName!
                      //           .toUpperCase(),
                      //       style: const TextStyle(fontSize: 18),
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //   ),
                      // ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: AutoSizeText(
                            viewModel.musterilerveSiparislerSuggestion[index]
                                    .musteriName!
                                    .toUpperCase(),
                          style: const TextStyle(fontSize: 18),
                          minFontSize: 14,
                          maxLines: 1,
                          textDirection: TextDirection.ltr,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              viewModel.updateSiparis(siparis);
                            },
                            icon: const Icon(
                                    Icons.done_outline_rounded,
                                    size: 30,
                                  ),
                            color: siparis.isDone?Colors.green.shade800:ColorConstants.instance.cancelColor,
                          ),
                          PopupMenuButton<int>(
                            initialValue: viewModel.popUpMenuValue,
                            onSelected: (item) async {
                              viewModel.popUpAction(
                                  item, siparis, index, context);
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 0,
                                child: Text('Güncelle'),
                              ),
                              const PopupMenuItem(
                                value: 1,
                                child: Text('Sil'),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  color: siparis.isDone
                      ? ColorConstants.instance.siparisCardDoneColor
                      : ColorConstants.instance.siparisCardNotDoneColor,
                ),
                child:ListTileTheme(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  minLeadingWidth: 0,
                  minVerticalPadding: 0.0,
                  child: IgnorePointer(
                    ignoring: siparis.adet!<=1,
                    child: ExpansionTile(
                      shape: Border.all(style: BorderStyle.none),
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      //maintainState: viewModel.expansionTileValues[index],
                      trailing: siparis.adet!<=1?SizedBox():null,
                      initiallyExpanded: false,
                      textColor: Colors.black,
                      key: PageStorageKey(siparis.id),
                      //trailing: SizedBox.shrink(),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (siparis.not != "") ...[Text("- " + siparis.not!)],
                          Container(
                            transform: siparis.adet!<=1?Matrix4.translationValues(28, 0, 0):null,
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "- " + siparis.kaydeden!,
                              style: const TextStyle(),
                            ),
                          )
                        ],
                      ),
                      onExpansionChanged: (value) {
                        //viewModel.createTempPartialOrderList(siparis);
                      },
                      title: Text(
                        viewModel.generateSiparisCardText(siparis)+(siparis.partialOrder!>0&&!siparis.isDone?"(${siparis.partialOrder} TANESİ TESLİM EDİLDİ)":""),
                        overflow: TextOverflow.fade,
                        style: const TextStyle(fontSize: 15),
                      ),
                      children: [
                        if(siparis.adet!>1)
                        for(int i=0;i<siparis.adet!;i++)...[
                          Container(
                            decoration: BoxDecoration(
                              color:viewModel.PartialOrderListLists[index][i]? ColorConstants.instance.siparisCardDoneColor:null,
                            ),
                            child: ListTile(
                              onTap: () {
                                viewModel.updatePartialOrderSiparis(siparis,i,index);
                              },

                              dense: true,
                              trailing: Icon(
                                  Icons.done_outline_rounded,
                                  size: 25,
                                  color: viewModel.PartialOrderListLists[index][i]?Colors.green.shade800:ColorConstants.instance.cancelColor,
                                ),
                              visualDensity: VisualDensity(vertical: -3),
                              title: Text(viewModel.generateSiparisCardTextWithoutAdet(siparis),style: TextStyle(fontSize: 15),),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 0,
          thickness: 1,
        )
      ],
    );
  }
}
