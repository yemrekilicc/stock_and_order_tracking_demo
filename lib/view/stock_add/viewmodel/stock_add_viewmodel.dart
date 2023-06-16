import 'dart:async';

import 'package:siparis_takip_demo/core/constants/text_constants.dart';
import 'package:siparis_takip_demo/core/init/firebase/query.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../core/base/base_viewmodel/base_viewmodel.dart';

class StockAddViewModel extends BaseViewModel{
  var scaffoldKey = GlobalKey<ScaffoldState>();

  List<DropdownMenuItem> subeDropDownItems=List.generate(CustomText.allTablesString["Subeler"]!.length, (index) => DropdownMenuItem(value: index,child: Text(CustomText.allTablesString["Subeler"]![index],),));
  late int subeDropDownValue;
  bool isWaiting=false;
  bool isWaitingButton=false;
  late List<TextEditingController> controllers ;
  List<Map<String,dynamic>> listSiparisler=[];
  List<Map<String,dynamic>> allListSiparisler=[];
  int indexCesit=0;
  int indexEbat=0;
  bool kalanStokSwitchValue=false;
  @override
  FutureOr<void> init()async {
    if (!isInitialized) {
      isInitialized = !isInitialized;
      changeStatus();
    }
    controllers = List.generate(
      calculateTotalListLength(),
          (index) => TextEditingController(),
    );
    isWaiting=true;
    subeDropDownValue = subeDropDownItems.first.value;
    allListSiparisler=await Querys.instance.getStokCount();
    allListSiparisler=await Querys.instance.getSiparisCount(allListSiparisler);
    listSiparisler=allListSiparisler.where((element) => element["sube"]==subeDropDownValue).toList();
    for(int i=CustomText.tableHierarchy.length-1;i>0;i--){
      listSiparisler.sort((a, b) => a[CustomText.tableHierarchy[i]["tableValueName"]].compareTo(b[CustomText.tableHierarchy[i]["tableValueName"]]),);
    }
    controllers.forEachIndexed((index,element){
      element.text=listSiparisler[index]["stok"].toString();
    });

    isWaiting=false;
    notifyListeners();
  }
  int calculateTotalListLength(){
    int listLength=1;
    for(int i=1;i<CustomText.tableHierarchy.length;i++){
      listLength=listLength*CustomText.allTablesString[CustomText.tableHierarchy[i]["tableName"]]!.length;
    }
    return listLength;
  }

  updateDropDown(int value) async {
    subeDropDownValue = value;
    isWaiting=true;
    notifyListeners();
    allListSiparisler=await Querys.instance.getStokCount();
    allListSiparisler=await Querys.instance.getSiparisCount(allListSiparisler);
    listSiparisler=allListSiparisler.where((element) => element["sube"]==subeDropDownValue).toList();
    for(int i=CustomText.tableHierarchy.length-1;i>0;i--){
      listSiparisler.sort((a, b) => a[CustomText.tableHierarchy[i]["tableValueName"]].compareTo(b[CustomText.tableHierarchy[i]["tableValueName"]]),);
    }
    controllers.forEachIndexed((index,element){
      element.text=listSiparisler[index]["stok"].toString();
    });

    isWaiting=false;
    notifyListeners();
  }

  dropDownChanged(int value){
    subeDropDownValue = value;
    listSiparisler=allListSiparisler.where((element) => element["sube"]==subeDropDownValue).toList();
    for(int i=CustomText.tableHierarchy.length-1;i>0;i--){
      listSiparisler.sort((a, b) => a[CustomText.tableHierarchy[i]["tableValueName"]].compareTo(b[CustomText.tableHierarchy[i]["tableValueName"]]),);
    }
    controllers.forEachIndexed((index,element){
      element.text=listSiparisler[index]["stok"].toString();
    });

    notifyListeners();
  }

  saveStock() async {
    isWaitingButton=true;
    notifyListeners();
    controllers.forEachIndexed((index,controller){
      listSiparisler[index]["stok"]=int.parse(controller.text) ;
    });
    await Querys.instance.updateStock(listSiparisler, subeDropDownValue);
    isWaitingButton=false;
    notifyListeners();
  }

  String generateListText(int index){
    String text="";
    for(int i=1;i<CustomText.tableHierarchy.length;i++){
      text="$text ${CustomText.allTablesString[CustomText.tableHierarchy[i]["tableName"]]![listSiparisler[index][CustomText.tableHierarchy[i]["tableValueName"]]]}";
    }
    return text;
  }

  changeKalanStokSwitchValue(bool value){
    kalanStokSwitchValue=value;
    notifyListeners();
  }

  reloadData()async{
    updateDropDown(subeDropDownValue);
  }

  @override
  void setContext(BuildContext context) {
  }
}