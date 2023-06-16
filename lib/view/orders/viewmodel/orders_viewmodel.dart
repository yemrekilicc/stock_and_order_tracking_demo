import 'dart:async';
import 'package:siparis_takip_demo/core/constants/navigation_constant.dart';
import 'package:siparis_takip_demo/core/constants/text_constants.dart';
import 'package:siparis_takip_demo/core/init/firebase/query.dart';
import 'package:siparis_takip_demo/model/siparisler_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/base/base_viewmodel/base_viewmodel.dart';

class OrdersViewModel extends BaseViewModel {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  ScrollController siparislerController=ScrollController();
  List<Siparisler> musterilerveSiparislerSuggestion = [];
  List<Siparisler> orjList = [];
  late Future<List<Siparisler>> siparisler;
  int popUpMenuValue= 0;
  bool isDescending = true;
  bool isWaiting = false;
  late List<bool> expansionTileValues;
  List<List<bool>> PartialOrderListLists=[];
  String saat="";
  //bool isDone=false;
  int isDone = -1;
  Map<String,int> filterSelection={};
  // int whichSube = -1;
  // int whichCesit = -1;
  // int whichEbat = -1;
  AsyncSnapshot<List<Siparisler>> lastSnapshot = const AsyncSnapshot.nothing();
  ScrollController scrollController = ScrollController();
  @override
  Future<FutureOr<void>> init() async {
    if (!isInitialized) {
      isInitialized = !isInitialized;
      changeStatus();
    }
    for(var element in CustomText.tableHierarchy){
      filterSelection["selected${element["tableValueName"]}"]=-1;
    }
    siparisler = Querys.instance.readMusterilerAndSiparisler();
    orjList=List.of(await siparisler);
    saat=DateTime.now().hour.toString()+":"+
        (DateTime.now().minute.toString().length==1?"0${DateTime.now().minute.toString()}":DateTime.now().minute.toString())+":"+
        (DateTime.now().second.toString().length==1?"0${DateTime.now().second.toString()}":DateTime.now().second.toString());

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   notifyListeners();
    //   debugPrint("ekran yenilendi");
    // });
  }

  @override
  void disposeFunction() {}
  sortAsc(bool value) async {
    isDescending = value;
    await sortAndFilter();
  }

  filterDone(int value) async {
    isDone = value;
    await sortAndFilter();
  }

  filter(int value,String tableName) async {
    filterSelection["selected$tableName"]=value;
    await sortAndFilter();
  }


  Future<List<Siparisler>> reloadMusterilerveSiparisler() async {
    saat=DateTime.now().hour.toString()+":"+
        (DateTime.now().minute.toString().length==1?"0${DateTime.now().minute.toString()}":DateTime.now().minute.toString())+":"+
        (DateTime.now().second.toString().length==1?"0${DateTime.now().second.toString()}":DateTime.now().second.toString());
    siparisler = Querys.instance.readMusterilerAndSiparisler();
    orjList=List.of(await siparisler);
    search();
    sortAndFilter();

    return siparisler;
  }

  sortAndFilter() {
    musterilerveSiparislerSuggestion = List.of(orjList);
    expansionTileValues=[];
    PartialOrderListLists=[];
    musterilerveSiparislerSuggestion.retainWhere((element) {
      final inputLower = searchController.text.toLowerCase();
      final patternLower = element.musteriName!.toLowerCase();
      return patternLower.contains(inputLower);
    });
    if (isDescending) {
      musterilerveSiparislerSuggestion
          .sort((b, a) => a.date!.compareTo(b.date!));
    } else {
      musterilerveSiparislerSuggestion
          .sort((a, b) => a.date!.compareTo(b.date!));
    }
    if (isDone != -1) {
      musterilerveSiparislerSuggestion.retainWhere(
          (element) => element.isDone == (isDone == 1 ? true : false));
    }
    for(var element in CustomText.tableHierarchy){
      if(filterSelection["selected${element["tableValueName"]}"]!=-1){
        musterilerveSiparislerSuggestion
            .retainWhere((e) {
              return e.tableValues![element["tableValueName"]] == filterSelection["selected${element["tableValueName"]}"];
            });
      }

    }
    for(int i=0;i<musterilerveSiparislerSuggestion.length;i++){
      PartialOrderListLists.add([]);
      if(musterilerveSiparislerSuggestion[i].adet!>1){
        PartialOrderListLists[i]=List.generate(musterilerveSiparislerSuggestion[i].adet!, (index) {
          if(index<musterilerveSiparislerSuggestion[i].partialOrder!){
            return true;
          }else{
            return false;
          }
        });
      }else{
        PartialOrderListLists[i]=[];
      }
    }
    notifyListeners();
  }

  setData() {
    sortAndFilter();
  }

  search() {
    musterilerveSiparislerSuggestion = List.of(orjList);
    musterilerveSiparislerSuggestion =
        musterilerveSiparislerSuggestion.where((element) {
      final inputLower = searchController.text.toLowerCase();
      final patternLower = element.musteriName!.toLowerCase();
      return patternLower.contains(inputLower);
    }).toList();
  }

  Future<void> deleteSiparis(Siparisler siparis) async {
    Querys.instance.deleteSiparis(siparis);
    await reloadMusterilerveSiparisler();
  }

  Future<void> updateSiparis(Siparisler siparis) async {
    siparis.isDone = !siparis.isDone;
    await Querys.instance.changeStatusSiparis(siparis);
    await reloadMusterilerveSiparisler();
  }

  Future<void> updatePartialOrderSiparis(Siparisler siparis,int index,int listIndex) async {
    if(PartialOrderListLists[listIndex][index]){
      if(siparis.isDone){
        siparis.isDone=false;
      }
      siparis.partialOrder=siparis.partialOrder! - 1;
      PartialOrderListLists[listIndex][index]=!PartialOrderListLists[listIndex][index];
    }else{
      siparis.partialOrder=siparis.partialOrder! + 1;
      PartialOrderListLists[listIndex][index]=!PartialOrderListLists[listIndex][index];
    }
    if(siparis.partialOrder==siparis.adet){
      siparis.isDone = true;
    }
    await Querys.instance.changeStatusPartialOrderSiparis(siparis,PartialOrderListLists[listIndex][index]);
    //await Querys.instance.changeStatusSiparis(siparis);
    await reloadMusterilerveSiparisler();
  }

  showDeleteDialog(BuildContext context, Siparisler siparis) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("İPTAL")),
          TextButton(
              onPressed: () {
                deleteSiparis(siparis).then((value) {
                  Navigator.pop(context);
                  if(kIsWeb){
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      notifyListeners();
                    });
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Sipariş silindi"),
                    ),
                  );
                }).catchError(
                  (error) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("HATA: $error"),
                    ),
                  ),
                );
              },
              child: const Text("SİL"))
        ],
        content: const Text("Sipariş silinsin mi?"),
      ),
    );
  }

  popUpAction(int value, Siparisler siparis,int index, BuildContext context) {
    popUpMenuValue = value;
    if(value==0){
      navigation.navigateToPage(
        path: NavigationConstants.CREATEORDER,
        data: musterilerveSiparislerSuggestion[index],
      ).then((value) {
        reloadMusterilerveSiparisler();
        //notifyListeners();
      });
    }
    else if(value==1){
       showDeleteDialog(context,siparis);
    }
  }
  int getSiparisCount(){
    int counter=0;
    for (var siparis in musterilerveSiparislerSuggestion) {
      counter+=siparis.adet!;
    }
    return counter;
  }

  resetFilters(){
     isDescending = true;
     isWaiting = false;
     isDone = -1;
     for(var element in CustomText.tableHierarchy){
       filterSelection["selected${element["tableValueName"]}"]=-1;
     }
     sortAndFilter();
  }

  String generateSiparisCardText(Siparisler siparis){
    String text="";
    text=siparis.adet.toString();
    for(int i=CustomText.tableHierarchy.length-1;i>=0;i--){
      var element=CustomText.tableHierarchy[i];
      text=text+" "+CustomText.allTablesString[element["tableName"]]![siparis.tableValues![element["tableValueName"]]!];
    }
    return text;
  }

  String generateSiparisCardTextWithoutAdet(Siparisler siparis){
    String text="";
    for(int i=CustomText.tableHierarchy.length-1;i>=0;i--){
      var element=CustomText.tableHierarchy[i];
      text=text+" "+CustomText.allTablesString[element["tableName"]]![siparis.tableValues![element["tableValueName"]]!];
    }
    return text;
  }
  @override
  void setContext(BuildContext context) {}
}
