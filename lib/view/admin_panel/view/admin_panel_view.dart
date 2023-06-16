import 'package:siparis_takip_demo/core/constants/color_constants.dart';
import 'package:siparis_takip_demo/core/constants/size_constants.dart';
import 'package:siparis_takip_demo/core/constants/text_constants.dart';
import 'package:siparis_takip_demo/core/extensions/context_extansion.dart';
import 'package:siparis_takip_demo/core/utils/drawers/navigation_drawer.dart';
import 'package:siparis_takip_demo/view/admin_panel/viewmodel/admin_panel_viewmodel.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_view/base_view.dart';

class AdminPanelView extends StatelessWidget {
  const AdminPanelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String pageInfo = ModalRoute.of(context)?.settings.arguments as String;
    return BaseView<AdminPanelViewModel>(
      viewModel: AdminPanelViewModel(),
      onModelReady: (model) async {
        model.setContext(context);
        await model.init(pageInfo: pageInfo);
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
                  backgroundColor: ColorConstants.instance.drawerTopColor,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.black),
                  actions: [
                    GestureDetector(
                      onTap: viewModel.isWaiting?null: () => viewModel.refreshPage(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: viewModel.isWaiting?const CircularProgressIndicator():const Icon(
                          Icons.replay,
                          size: 30,
                        ),
                      ),
                    )
                    // IconButton(
                    //     onPressed:viewModel.isWaiting?null: () => viewModel.refreshPage(),
                    //     icon: Icon(
                    //       Icons.replay,
                    //     ))
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

  Widget buildBody(AdminPanelViewModel viewModel, BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SizeConstant.instance!.wideScreenWidth),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for(var table in CustomText.tableHierarchy)...[
                viewModel.allTables[table["tableName"]]!=null?
                CustomListView(
                  title: table["tableName"],
                  viewModel: viewModel,
                  itemList: viewModel.allTables[table["tableName"]]!,
                  itemName: table["tableValueName"],
                ):Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: const CircularProgressIndicator(),
                ),
                const Divider(),
              ],
              SizedBox(
                width: context.dynamicWidth(1)-20,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.instance.buttonColor),
                    onPressed: () {
                      viewModel.saveLists(context).then((value) => null);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content:
                      //     Text("Eklenen adet sayısı kalan stoktan fazla olamaz"),
                      //   ),
                      // );
                    },
                    child: const Text(
                      "KAYDET",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    )),
              ),
              const SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListView extends StatelessWidget {
  CustomListView({
    required this.title,
    required this.itemName,
    required this.viewModel,
    required this.itemList,
    super.key,
  });
  String title;
  String itemName;
  AdminPanelViewModel viewModel;
  List<String> itemList;

  @override
  Widget build(BuildContext context) {

    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      children: [
        Center(child: Text(title ,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold))),
        for (final item in itemList)...[
          Container(
            key: ValueKey(item),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: const Border(bottom: BorderSide(width: 2,color: Colors.black26))
              ),
              child: ListTile(
                title: Text(item),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(viewModel.delete)...[
                      IconButton(
                        onPressed: () {
                          viewModel.deleteItemFromList(itemList,item,itemName,context);
                        },
                        icon: Icon(Icons.delete_outline,color: ColorConstants.instance.cancelColor,),
                      )
                    ],
                    if(viewModel.update)...[
                      IconButton(
                        onPressed: () {
                          viewModel.editListItem(context, itemName, itemList, item);
                        },
                        icon: const Icon(Icons.mode_edit_outlined,color: Colors.blueGrey,),
                      ),
                    ]

                  ],
                ),
              ),
            ),
          ),
          // if(viewModel.subeDropDownItems.last!=item)
          //   Divider(key: UniqueKey(),),
        ],
        if(viewModel.add)...[
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  )
              ),
              onPressed: () {
                viewModel.addItemToList(context,itemName,itemList,title);

              },
              child: const Center(child: Icon(Icons.add,color: Colors.black,size: 30,),),
            ),
          )
        ]
        ,
      ],
    );
  }
}

class CustomReordeableListView extends StatelessWidget {
  CustomReordeableListView({
    required this.title,
    required this.itemName,
    required this.viewModel,
    required this.itemList,
    super.key,
  });
  String title;
  String itemName;
  AdminPanelViewModel viewModel;
  List<String> itemList;

  @override
  Widget build(BuildContext context) {

    return ReorderableListView(
      header: Center(child: Text(title ,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold))),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,

      padding: const EdgeInsets.all(10),
      footer: Container(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[200],
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            )
          ),
          onPressed: () {
            viewModel.addItemToList(context,itemName,itemList,title);

          },
          child: const Center(child: Icon(Icons.add,color: Colors.black,size: 30,),),
        ),
      ),
      children: [
        for (final item in itemList)...[
          Container(
            key: ValueKey(item),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: const Border(bottom: BorderSide(width: 2,color: Colors.black26))
              ),
              child: ListTile(
                title: Text(item),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        viewModel.deleteItemFromList(itemList,item,itemName,context);
                      },
                      icon: Icon(Icons.delete_outline,color: ColorConstants.instance.cancelColor,),
                    ),
                    IconButton(
                      onPressed: () {
                        viewModel.editListItem(context, itemName, itemList, item);
                        //viewModel.deleteItemFromList(itemList,item);
                      },
                      icon: const Icon(Icons.mode_edit_outlined,color: Colors.blueGrey,),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // if(viewModel.subeDropDownItems.last!=item)
          //   Divider(key: UniqueKey(),),
        ]

      ],
      onReorder: (oldIndex, newIndex) {
        viewModel.updateItemOrder(oldIndex, newIndex,itemList);
      },
    );
  }
}

