import 'dart:async';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:siparis_takip_demo/core/base/base_viewmodel/base_viewmodel.dart';
import 'package:siparis_takip_demo/core/constants/color_constants.dart';
import 'package:siparis_takip_demo/core/constants/navigation_constant.dart';
import 'package:siparis_takip_demo/core/constants/text_constants.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/init/firebase/auth.dart';
import 'package:siparis_takip_demo/model/user_model.dart';
import 'package:siparis_takip_demo/view/orders/view/orders_view.dart';
import 'package:siparis_takip_demo/view/orders/viewmodel/orders_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/base/base_view/base_view.dart';

class filterOrderDrawer extends StatefulWidget {

  filterOrderDrawer({
    required this.viewModel,
    Key? key
  }) : super(key: key);
  OrdersViewModel viewModel;
  @override
  State<filterOrderDrawer> createState() => _filterOrderDrawerState();
}

class _filterOrderDrawerState extends State<filterOrderDrawer> {
  @override
  Widget build(BuildContext context) {
    return BaseView<OrdersViewModel>(
      viewModel: widget.viewModel,
      onModelReady: (model) async {
        model.setContext(context);
        await model.init();
      },
      onPageBuilder: (context, viewModel, child) =>
          buildBody(viewModel, context),
    );
  }

  Widget buildBody(OrdersViewModel viewModel, BuildContext context) {
    return Drawer(
      shape: Border.all(style: BorderStyle.none),
      backgroundColor: ColorConstants.instance.backgroundColor,
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: ColorConstants.instance.drawerTopColor
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Text("SIRALAMA ", style: TextStyle(fontSize: 18)),
                  FilterOption(
                    viewModel: viewModel,
                    titleText: "Zamana göre :",
                    optionsText: const ["Yeniden Eskiye", "Eskiden Yeniye"],
                    optionsValue: const [true, false],
                    groupValue: viewModel.isDescending,
                    updateFunction: (value) {
                      setState(() {
                        viewModel.sortAsc(value!);
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
                    viewModel: viewModel,
                    titleText: "Sipariş durumuna göre :",
                    optionsText: const ["Teslim Edilmiş", "Teslim Edilmemiş"],
                    optionsValue: const [1, 0],
                    groupValue: viewModel.isDone,
                    updateFunction: (value) {
                      setState(() {
                        if (value == null) {
                          viewModel.filterDone(-1);
                        } else {
                          viewModel.filterDone(value);
                        }
                      });
                    },
                    crossAxisCount: 2,
                    toggleable: true,
                  ),
                  for(var element in CustomText.tableHierarchy)...[
                    FilterOption(
                      viewModel: viewModel,
                      titleText: "${element["tableName"]}",
                      optionsText: CustomText.allTablesString[element["tableName"]]!,
                      groupValue: viewModel.filterSelection["selected${element["tableValueName"]}"],
                      updateFunction: (value) {
                        setState(() {
                          if (value == null) {
                            viewModel.filter(-1,element["tableValueName"]);
                          } else {
                            viewModel.filter(value,element["tableValueName"]);
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
                            viewModel.resetFilters();
                          });
                        },
                        child: const Text(
                          "SIFIRLA",
                          style: TextStyle(fontSize: 16),
                        )),
                  ),
                  // SizedBox(
                  //   height: 20,
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class FilterOption<T> extends StatefulWidget {
  FilterOption(
      {required this.viewModel,
        required this.titleText,
        required this.optionsText,
        this.optionsValue,
        required this.groupValue,
        required this.updateFunction,
        required this.crossAxisCount,
        required this.toggleable,
        super.key}) {
    optionsValue ??= List.generate(optionsText.length, (index) => index as T);
  }
  OrdersViewModel viewModel;
  String titleText;
  List<String> optionsText;
  List<T>? optionsValue;
  T groupValue;
  void Function(dynamic)? updateFunction;
  double crossAxisCount;
  bool toggleable;

  @override
  State<FilterOption> createState() => _FilterOptionState();
}

class _FilterOptionState extends State<FilterOption> {
  @override
  Widget build(BuildContext context) {
    void Function(dynamic)? newUpdateFunction = (value) {
      widget.updateFunction!(value);
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4),
          child: Text(
            widget.titleText,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        AlignedGridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          itemCount: widget.optionsText.length,
          itemBuilder: (context, index) {
            return Container(
              //height: 50,
              alignment: Alignment.center,
              child: RadioListTile(
                value: widget.optionsValue![index],
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(widget.optionsText[index],
                    style: const TextStyle(fontSize: 16)),
                groupValue: widget.groupValue,
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                activeColor: ColorConstants.instance.buttonColor,
                toggleable: widget.toggleable,
                onChanged: newUpdateFunction,
              ),
            );
          },
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}