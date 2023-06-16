import 'dart:async';

import 'package:siparis_takip_demo/core/base/base_viewmodel/base_viewmodel.dart';
import 'package:siparis_takip_demo/core/constants/color_constants.dart';
import 'package:siparis_takip_demo/core/constants/text_constants.dart';
import 'package:siparis_takip_demo/core/extensions/string_extansion.dart';
import 'package:siparis_takip_demo/core/init/firebase/query.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class AdminPanelViewModel extends BaseViewModel{

  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController itemAddController=TextEditingController();
  bool isWaiting=false;

  Map<String,List<String>> allTables={};
  Map<String,List<String>> orjAllTables={};
  Map<String,List<String>> deletedItems={};
  Map<String,List<String>> addedItems={};
  Map<String,List<Map<String,String>>> updatedItems={};
  bool update=false;
  bool delete=false;
  bool add=false;

  @override
  FutureOr<void> init({String? pageInfo}) async{
    if (!isInitialized) {
      isInitialized = !isInitialized;
      changeStatus();
    }
    if(pageInfo=="update"){
      update=true;
    }else if(pageInfo=="delete"){
      delete=true;
    }else if(pageInfo=="add"){
      add=true;
    }
    //CustomText.tableHierarchy=await getTableHierarchy();
    for(var element in CustomText.tableHierarchy){
      allTables[element["tableName"]]=await Querys.instance.getTableValues("${element["tableValueName"]}".capitalize());
      deletedItems[element["tableValueName"]]=[];
      addedItems[element["tableValueName"]]=[];
      updatedItems[element["tableValueName"]]=[];
    }
    orjAllTables.addAll(allTables);

    notifyListeners();

  }

  refreshPage()async{
    isWaiting=true;
    notifyListeners();
    for(var element in CustomText.tableHierarchy){
      allTables[element["tableName"]]=await Querys.instance.getTableValues("${element["tableValueName"]}".capitalize());
      deletedItems[element["tableValueName"]]=[];
      addedItems[element["tableValueName"]]=[];
      updatedItems[element["tableValueName"]]=[];
    }
    isWaiting=false;
    notifyListeners();
  }



  // Future<List<String>> getCesitDropDownValues() async {
  //   return Querys.instance.getCesitNames();
  // }
  //
  // Future<List<String>> getSubeDropDownValues() async {
  //   return Querys.instance.getSubeNames();
  // }
  //
  // Future<List<String>> getEbatDropDownValues() async {
  //   return Querys.instance.getEbatNames();
  // }

  Future<List<Map<String,dynamic>>> getTableHierarchy() async {
    return Querys.instance.getTableHierarchy();
  }

  void updateItemOrder(int oldIndex, int newIndex,List<String> itemList) {
    // this adjustment is needed when moving down the list
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    // get the tile we are moving
    final String tile = itemList.removeAt(oldIndex);
    // place the tile in new position
    itemList.insert(newIndex, tile);

    notifyListeners();
  }
  
  void addItemToList(BuildContext context,String itemName,List<String> itemList,String tableName){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(

        title: FittedBox(fit: BoxFit.fitWidth,child: Text("Eklenecek $itemName Adını Giriniz")),
        titleTextStyle: const TextStyle(fontSize: 20,color: Colors.black),
        contentPadding: const EdgeInsets.all(16),
        buttonPadding: EdgeInsets.zero,
        actionsPadding: const EdgeInsets.all(8),
        actions: [
          TextButton(
              onPressed: () {
                itemAddController.text="";
                Navigator.pop(context);
              },
              child: const Text("İptal")),
          TextButton(
              onPressed: () {
                if(itemList.contains(itemAddController.text)){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                      Text("Aynı isimde iki nesne eklenemez")));
                }else{
                  addedItems[itemName]!.add(itemAddController.text);
                  itemList.add(itemAddController.text);
                }
                itemAddController.text="";
                Navigator.pop(context);
                if(kIsWeb){
                  notifyListeners();
                }
              },
              child: const Text("Kaydet"))
        ],
        content: TextField(
          controller: itemAddController,
          decoration: const InputDecoration(
            isDense: true
          ),

        ),
      ),
    );
  }

  Future saveLists(BuildContext context)async{
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("BU İŞLEMDEN SONRA SİLİNENLERİ İÇEREN SİPARİŞLER SİLİNECEKTİR örn: Sultan Çeşitini silersen sultan içeren siparisler silinecektir!",style: TextStyle(color: ColorConstants.instance.cancelColor,fontWeight: FontWeight.bold),),
        title: const FittedBox(fit: BoxFit.fitWidth,child: Text("KAYIT TAMAMLANSIN MI")),
        titleTextStyle: const TextStyle(fontSize: 20,color: Colors.black),
        titlePadding: const EdgeInsets.all(16),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
        actions: [
          TextButton(
              onPressed: () {

                Navigator.pop(context);
              },
              child: const Text("İptal")),
          TextButton(
              onPressed:isWaiting?null:() async{
                isWaiting=true;
                notifyListeners();
                await Querys.instance.adminPanelUpdateItem(updatedItems);

                CustomText.tableHierarchy=await Querys.instance.getTableHierarchy();
                for(var element in CustomText.tableHierarchy){
                  CustomText.allTablesString[element["tableName"]]=await Querys.instance.getTableValues("${element["tableValueName"]}".capitalize());
                }

                await Querys.instance.adminPanelDelete(deletedItems);
                CustomText.tableHierarchy=await Querys.instance.getTableHierarchy();
                for(var element in CustomText.tableHierarchy){
                  CustomText.allTablesString[element["tableName"]]=await Querys.instance.getTableValues("${element["tableValueName"]}".capitalize());
                }

                await Querys.instance.adminPanelAddItem(addedItems);
                CustomText.tableHierarchy=await Querys.instance.getTableHierarchy();
                for(var element in CustomText.tableHierarchy){
                  CustomText.allTablesString[element["tableName"]]=await Querys.instance.getTableValues("${element["tableValueName"]}".capitalize());
                }
                isWaiting=false;
                notifyListeners();

                Navigator.pop(context);
              },
              child: const Text("Kaydet"))
        ],
      ),
    );
  }

  // String generatePath(){
  //   tableHierarchy
  // }

  editListItem(BuildContext context,String title,List<String> itemList,String item){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(

        title: FittedBox(fit: BoxFit.fitWidth,child: Text("Güncellenecek $title Adını Giriniz")),
        titleTextStyle: const TextStyle(fontSize: 20,color: Colors.black),
        contentPadding: const EdgeInsets.all(16),
        buttonPadding: EdgeInsets.zero,
        actionsPadding: const EdgeInsets.all(8),
        actions: [
          TextButton(
              onPressed: () {
                itemAddController.text="";
                Navigator.pop(context);
              },
              child: const Text("İptal")),
          TextButton(
              onPressed: () async{
                updatedItems[title]!.add({"old":itemList[itemList.indexWhere((element) => element==item)],"new":itemAddController.text});
                itemList[itemList.indexWhere((element) => element==item)]= itemAddController.text;
                itemAddController.text="";
                Navigator.pop(context);
              },
              child: const Text("Kaydet"))
        ],
        content: TextField(
          controller: itemAddController,
          decoration: const InputDecoration(
              isDense: true
          ),

        ),
      ),
    );

  }
  void deleteItemFromList(List<String> itemList,String item,String itemKey,BuildContext context){
    deletedItems[itemKey]!.add(item);
    itemList.remove(item);
    if(itemList.isEmpty){
      itemList.add(item);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
          Text("TABLODAKİ BÜTÜN ÖĞELER SİLİNEMEZ")));
    }
    notifyListeners();
  }



  @override
  void setContext(BuildContext context) {

  }


}