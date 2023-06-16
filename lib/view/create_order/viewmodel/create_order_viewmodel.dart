import 'dart:async';
import 'package:siparis_takip_demo/core/constants/text_constants.dart';
import 'package:siparis_takip_demo/core/init/firebase/query.dart';
import 'package:siparis_takip_demo/model/musteriler_model.dart';
import 'package:siparis_takip_demo/model/siparisler_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../core/base/base_viewmodel/base_viewmodel.dart';

class CreateOrderViewModel extends BaseViewModel {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerNot = TextEditingController();
  String selectedName = "";
  Musteriler? selectedMusteri;
  int adetCounter = 1;
  List<Siparisler> siparisler = [];
  bool fastAddEnable = true;
  bool isUpdate = false;
  Siparisler? updateSip;
  Siparisler? orjUpdateSip;
  //late Stream<List<Musteriler>> futureMusteriler;

  Map<String,List<DropdownMenuItem<int>>> dropDownItemsMap={};

  Map<String,int> dropDownValueMap={};

  int? remainingStock;
  @override
  Future<FutureOr<void>> init({Siparisler? siparis}) async {
    if (!isInitialized) {
      isInitialized = !isInitialized;
      changeStatus();
    }
    // CustomText.tableHierarchy=await Querys.instance.getTableHierarchy();
    // for(var element in CustomText.tableHierarchy){
    //   CustomText.allTablesString[element["tableName"]]=await Querys.instance.getTableValues("${element["tableValueName"]}".capitalize());
    // }

    for(var element in CustomText.tableHierarchy){
      dropDownValueMap["${element["tableValueName"]}DropDownValue"]=0;
    }
    if (siparis != null) {
      isUpdate = true;
      await getDropDownsValues();

      for(var element in CustomText.tableHierarchy){
        dropDownValueMap["${element["tableValueName"]}DropDownValue"]=dropDownItemsMap["${element["tableValueName"]}DropDownItems"]![siparis.tableValues![element["tableValueName"]]!].value!;
      }
      adetCounter = siparis.adet!;
      controllerNot.text = siparis.not!;
      selectedName = siparis.musteriName!;
      updateSip = siparis;
      orjUpdateSip = siparis;
      controllerName.text = siparis.musteriName!;
      selectedMusteri=await getMusteriById(siparis.musteriId!);
    } else {
      await getDropDownsValues();
      for(var element in CustomText.tableHierarchy){
        dropDownValueMap["${element["tableValueName"]}DropDownValue"]=dropDownItemsMap["${element["tableValueName"]}DropDownItems"]!.first.value!;
      }
    }
    await getRemainingStock();

    //isLoading=false;
    //debugPrint("veri çekildi");

    // WidgetsBinding.instance.addPostFrameCallback((_) async{
    //   await Future.delayed(Duration(milliseconds: 500));
    // });
  }

  Future getMusteriById(String id)async{
    return await Querys.instance.getMusteriById(id);
  }

  Future getDropDownsValues()async{
    for(var element in CustomText.tableHierarchy){
      dropDownItemsMap["${element["tableValueName"]}DropDownItems"]=List.generate(
        CustomText.allTablesString[element["tableName"]]!.length,
            (index) => DropdownMenuItem(
          value: index,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(CustomText.allTablesString[element["tableName"]]![index]),
          ),
        ),
      );
    }
  }

  updateDropDown(int value,String valueName) async {
    dropDownValueMap["${valueName}DropDownValue"]=value;
    await getRemainingStock();
  }

  getRemainingStock() async {
    remainingStock = await Querys.instance
        .remainingStock(
            dropDownValueMap)
        .whenComplete(() => notifyListeners());
    if (orjUpdateSip != null) {
      if (check()&&
          remainingStock != null) {
        remainingStock = orjUpdateSip!.adet! + remainingStock!;
      }
    }
  }

  bool check(){
    bool check=true;
    for(var element in CustomText.tableHierarchy){
      if(orjUpdateSip!.tableValues![element["tableValueName"]]!=dropDownValueMap["${element["tableValueName"]}DropDownValue"]){
        check=false;
      }
    }
    return check;
  }

  addSiparis() {
    remainingStock=remainingStock!-adetCounter;
    siparisler.add(Siparisler(
        adet: adetCounter,
        tableValues: {for(var e in CustomText.tableHierarchy) e["tableValueName"] : dropDownValueMap["${e["tableValueName"]}DropDownValue"]!},
        not: controllerNot.value.text,
        ));
    notifyListeners();
  }

  updateSiparis(BuildContext context) async {
    updateSip!.adet = adetCounter;
    updateSip!.tableValues={for(var e in CustomText.tableHierarchy) e["tableValueName"] : dropDownValueMap["${e["tableValueName"]}DropDownValue"]!};
    updateSip!.not = controllerNot.value.text;
    if(updateSip!.partialOrder!>=adetCounter){
      updateSip!.partialOrder=adetCounter;
      updateSip!.isDone=true;
    }else{
      updateSip!.isDone=false;
    }
    await Querys.instance
        .updateSiparis(updateSip!)
        .then(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Siparis Güncellendi"),
            ),
          ),
        )
        .catchError(
          (error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("hata $error"),
            ),
          ),
        );
    navigation.popPage();

    // navigation.popAndPushNamedPage(
    //     path: NavigationConstants.ORDERS).then((_) => notifyListeners());

    // navigation.pushReplacementNamed(
    // path: NavigationConstants.ORDERS).then((_) => notifyListeners());

    //await getRemainingStock();
  }

  deleteSiparis(int index) {
    remainingStock=siparisler[index].adet!+remainingStock!;
    siparisler.removeAt(index);
    notifyListeners();
  }

  incAdet() {
    adetCounter++;
    notifyListeners();
  }

  decAdet() {
    if (adetCounter > 1) adetCounter--;
    notifyListeners();
  }

  Future<void> addFastContact() async {
    selectedMusteri = Musteriler(
      adi: controllerName.value.text,
    );
    Querys.instance.saveMusteri(selectedMusteri!);
    notifyListeners();
  }

  Future<void> saveSiparisler() async {
    Querys.instance.saveSiparis(siparisler, selectedMusteri!.id!);
  }

  selectMusteri(String suggestion, List<Musteriler> snapshotData) {
    selectedMusteri =
        snapshotData.firstWhere((element) => element.adi.contains(suggestion));
    controllerName.text = suggestion;
    if(kIsWeb){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }

  }

  removeSelectedMusteri() {
    controllerName.text = "";
    selectedMusteri = null;
    notifyListeners();
  }

  Future createOrder(BuildContext context) async {
    if (controllerName.value.text != "") {
      FocusScope.of(context).unfocus();
      fastAddEnable = false;
      await addFastContact()
          .then(
            (_) => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Kişi kaydedildi"),
              ),
            ),
          )
          .catchError(
            (error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("hata $error"),
              ),
            ),
          );
      fastAddEnable = true;
    }
  }

  String generateText(int index){
    String text="";
    for(int i=CustomText.tableHierarchy.length-1;i>=0;i--){
      var element=CustomText.tableHierarchy[i];
      text=text+" "+CustomText.allTablesString[element["tableName"]]![siparisler[index].tableValues![element["tableValueName"]]!];
    }
    return text;
  }

  @override
  void setContext(BuildContext context) {}
}
