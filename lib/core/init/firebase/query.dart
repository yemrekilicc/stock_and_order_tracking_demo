import 'dart:developer';

import 'package:siparis_takip_demo/core/constants/text_constants.dart';
import 'package:siparis_takip_demo/core/extensions/string_extansion.dart';
import 'package:siparis_takip_demo/model/musteriler_model.dart';
import 'package:siparis_takip_demo/model/siparisler_model.dart';
import 'package:siparis_takip_demo/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class Querys {
  static Querys _instance = Querys._init();
  static Querys get instance => Querys._instance;
  Querys._init();
  final _musterilerQuery= FirebaseFirestore.instance.collection('Musteriler');
  final _siparislerQuery=  FirebaseFirestore.instance.collection('Siparisler');

  Stream<List<Musteriler>> readMusterilerStream() => _musterilerQuery
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            var data = doc.data();
            return Musteriler.fromJson(data);
          }).toList());

  // Future<List<Musteriler>> readMusterilerr()async {
  //   var musteriler=await _musterilerQuery.get();
  //
  //
  //
  //   return _musterilerQuery
  //     .get()
  //     .map((snapshot) => snapshot.docs.map((doc) {
  //   var data = doc.data();
  //   return Musteriler.fromJson(data);
  // }).toList());
  // }
  
  Future<List<Map<String,dynamic>>> getStokCount() async {
    List<Map<String,dynamic>> listSiparisler=[];
    //await getStokCountDynamic(loopDepth, list, removeCounter, initialDepth, first, listSiparisler);

    var ref=await FirebaseFirestore.instance.collection("Stok").get();

    for (var doc in ref.docs) {
      listSiparisler.add(doc.data()["tableValues"]);
      listSiparisler.last["stok"]=doc.data()["stok"];
      listSiparisler.last["id"]=doc.id;
    }

    // for(var indexCesit = 0 ; indexCesit <CustomText.cesitString.length ; indexCesit++){
    //   //TODO
    //
    //   for(var indexEbat = 0 ; indexEbat <CustomText.ebatString.length ; indexEbat++){
    //     var refCesit = await _subelerQuery.doc(sube.toString()).collection("Cesitler").
    //     doc(indexCesit.toString()).collection("Ebatlar").doc(indexEbat.toString()).get();
    //
    //     var data=refCesit.data();
    //     listSiparisler.add({"cesit":indexCesit,"ebat":indexEbat,"stok":data!["stok"]});
    //   }
    // }

    return listSiparisler;
  }


  Future updateStock(List<Map<String,dynamic>> list, int sube)async{
    final batch = FirebaseFirestore.instance.batch();

    for (var element in list) {
      //TODO
      var ref=FirebaseFirestore.instance.collection("Stok").doc(element["id"]);
      // for(var element in CustomText.tableHierarchy){
      //   if(first){
      //     ref= FirebaseFirestore.instance.collection(element["tableName"]).doc(list[element["tableValueName"]].toString());
      //     first=!first;
      //   }else{
      //     ref=ref.collection(element["tableName"]).doc(list[element["tableValueName"]].toString());
      //   }
      // }
      //var ref = FirebaseFirestore.instance.collection("Subeler").doc(sube.toString()).collection("Cesitler").doc(element["cesit"].toString()).collection("Ebatlar").doc(element["ebat"].toString());
      batch.update(ref,{"stok":element["stok"]});
    }
    await batch.commit();
  }


  Future<List<String>> getTableValues(String tableName)async{
    List<String> tableValues=[];
    var refTableValues=await FirebaseFirestore.instance.collection("${tableName}Names").orderBy("id").get();
    tableValues=refTableValues.docs.map((tableValue) {
      return tableValue.data()["name"] as String;
    }).toList();
    return tableValues;
  }
  // Future<List<String>> getSubeNames()async{
  //   List<String> SubeNames=[];
  //   var refSubeNames=await FirebaseFirestore.instance.collection("SubeNames").get();
  //   SubeNames=refSubeNames.docs.map((subeName) {
  //     return subeName.data()["name"] as String;
  //   }).toList();
  //   return SubeNames;
  // }
  // Future<List<String>> getEbatNames()async{
  //   List<String> EbatNames=[];
  //   var refEbatNames=await FirebaseFirestore.instance.collection("EbatNames").get();
  //   EbatNames=refEbatNames.docs.map((EbatName) {
  //     return EbatName.data()["name"] as String;
  //   }).toList();
  //   return EbatNames;
  // }

  ///stok tablosunu oluşturmak için
  // Future createStock()async{
  //   List<List<int>> list=List.generate(CustomText.cesitString.length, (index) => List.generate(CustomText.cesitString.length, (index) => 0));
  //   final batch = FirebaseFirestore.instance.batch();
  //   //var refsube = FirebaseFirestore.instance.collection("SubelerStok").doc(sube);
  //   //batch.set(refsube, {"id":sube});
  //   for(var sube =0;sube <CustomText.cesitString.length ; sube++){
  //     var refsube = FirebaseFirestore.instance.collection("SubelerStok").doc(sube.toString());
  //     batch.set(refsube, {"subeName":CustomText.subeString[sube],"id":sube});
  //     for(var cesit = 0 ; cesit <CustomText.cesitString.length ; cesit++) {
  //       var refcesit = FirebaseFirestore.instance.collection("SubelerStok").doc(sube).collection(cesit.toString());
  //       for (var ebat = 0; ebat < CustomText.ebatString.length; ebat++) {
  //         var ref = FirebaseFirestore.instance.collection("SubelerStok").doc(sube).collection(cesit.toString()).doc(ebat.toString());
  //         batch.set(ref,{"stok":10 ,"name":("${CustomText.ebatString[ebat]} ${CustomText.cesitString[cesit]}")});
  //       }
  //     }
  //   }
  //
  //   await batch.commit();
  // }

  ///SubelerStok tablosunu oluşturmak için
  Future createStok()async{
    final batch = FirebaseFirestore.instance.batch();

    for(var sube = 0 ; sube <3 ; sube++){
      // var refsube = FirebaseFirestore.instance.collection("Subeler").doc(sube.toString());
      // batch.set(refsube, {"subeName":subeString[sube],"id":sube});
      for(var cesit = 0 ; cesit <6 ; cesit++) {
        // var refcesit = FirebaseFirestore.instance.collection("Subeler").doc(sube.toString()).collection("Cesitler").doc(cesit.toString());
        // batch.set(refcesit, {"cesitName":cesitString[cesit],"id":cesit});
        for (var ebat = 0; ebat < 2; ebat++) {
          var ref=FirebaseFirestore.instance.collection("Stok").doc();
          batch.set(ref, {"id":ref.id,"stok":10,"tableValues":{"sube":sube,"cesit":cesit,"ebat":ebat}});
          // var refebat = FirebaseFirestore.instance.collection("Subeler").doc(sube.toString()).collection("Cesitler").doc(cesit.toString()).collection("Ebatlar").doc(ebat.toString());
          // batch.set(refebat, {"ebatName":ebatString[ebat],"id":ebat,"stok":10});
        }
      }
    }
    await batch.commit();
  }

  ///names tablolarını oluşturmak için
  Future createcesit()async{
    final batch = FirebaseFirestore.instance.batch();
    List<String> cesitString=["BAKLAVA","SULTAN","VEZİR PARMAĞI","BURMA","DİLBER DUDAĞI","EV TİPİ BAKLAVA"];
    for(var cesit = 0 ; cesit <cesitString.length ; cesit++){
      var refsube = FirebaseFirestore.instance.collection("CesitNames").doc(cesit.toString());
      batch.set(refsube, {"name":cesitString[cesit],"id":cesit});
    }
    await batch.commit();
  }
  Future createebat()async{
    final batch = FirebaseFirestore.instance.batch();
    List<String> ebatString=["KÜÇÜK","BÜYÜK"];
    for(var ebat = 0 ; ebat <ebatString.length ; ebat++){
      var refsube = FirebaseFirestore.instance.collection("EbatNames").doc(ebat.toString());
      batch.set(refsube, {"name":ebatString[ebat],"id":ebat});
    }
    await batch.commit();
  }
  Future createsube()async{
    final batch = FirebaseFirestore.instance.batch();

    List<String> subeString=["ÇARŞI","İMALAT","GOP"];
    for(var sube = 0 ; sube <subeString.length ; sube++){
      var refsube = FirebaseFirestore.instance.collection("SubeNames").doc(sube.toString());
      batch.set(refsube, {"name":subeString[sube],"id":sube});
    }
    await batch.commit();
  }

  Future<int> remainingStock(Map<String,dynamic> siparisValues)async{
    int remainingStock=-1;
    int count=0;
    bool first=true;
    try{
      var refSiparisCount=_siparislerQuery.where("isDone",isEqualTo: false);
      var refStokCount;
      for(var element in CustomText.tableHierarchy){
        refSiparisCount=refSiparisCount.where("tableValues.${element["tableValueName"]}",isEqualTo: siparisValues["${element["tableValueName"]}DropDownValue"]);
      }
      var siparisCount=await refSiparisCount.get();
      for(var element in CustomText.tableHierarchy){
        if(first){
          refStokCount=FirebaseFirestore.instance.collection("Stok").where("tableValues.${element["tableValueName"]}",isEqualTo: siparisValues["${element["tableValueName"]}DropDownValue"]);
          first=!first;
        }else{
          refStokCount=refStokCount.where("tableValues.${element["tableValueName"]}",isEqualTo: siparisValues["${element["tableValueName"]}DropDownValue"]);
        }
      }
      var stokCount=await refStokCount.get();
      siparisCount.docs.forEach((element) {
        count += element.data()["adet"] as int;
      });
      remainingStock=stokCount.docs.first.data()!["stok"]-count;
      if(remainingStock<=0){
        remainingStock=0;
      }
    }on FirebaseException catch(e){
      print(e);
      rethrow;
    }
    return remainingStock;
  }


  Future<List<Map<String,dynamic>>> getSiparisCount(List<Map<String,dynamic>> listSiparisler) async {
    //await getsiparisCountDynamic(loopDepth, list, removeCounter, initialDepth, first, listSiparisler, data, counter);


    QuerySnapshot<Map<String, dynamic>> data=await FirebaseFirestore.instance.collection("Siparisler").get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> adet=data.docs.toList();
    for(var siparis in listSiparisler){
      int siparisCount=0;
      for(var variableName in CustomText.tableHierarchy){
        adet=adet.where((element) => element.data()["tableValues"][variableName["tableValueName"]]==siparis[variableName["tableValueName"]]).toList();
      }
      adet=adet.where((element) => element.data()["isDone"]==false).toList();
      adet.forEach((element) {
        siparisCount += element["adet"] as int;
        if(element.data().containsKey("partialOrder")){
          if(element["partialOrder"]!=null){
            siparisCount -= element["partialOrder"] as int;
          }
        }
      });
      siparis["siparis"]=siparisCount;
      adet=data.docs.toList();

    }
    return listSiparisler;
  }


  Future<List<Siparisler>> readMusterilerAndSiparisler() async{
    QuerySnapshot<Map<String, dynamic>> siparislerQuery;

    siparislerQuery= await _siparislerQuery.orderBy("date",descending: true).get();

    List<Siparisler> siparisler=siparislerQuery.docs.map((siparis) => Siparisler.fromJson(siparis.data())).toList();

    await _musterilerQuery.get().then((musteriler) {
      for (Siparisler siparis in siparisler){
        final data=musteriler.docs.firstWhere((element) => element.id==siparis.musteriId);
        siparis.musteriName=data.data()["adi"];
      }
    });

    return siparisler;
  }


  deleteSiparis(Siparisler siparis)async{
    await _siparislerQuery.doc(siparis.id)
        .delete();
  }

  deleteSiparisByValue(int value,String fieldName)async{

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await _siparislerQuery.where(fieldName,isEqualTo: value).get();
      for (var element in snapshot.docs) {
        transaction.delete(_siparislerQuery.doc(element.id));
      }
    }).then(
          (value) => print(""),
      onError: (e) => print("Error updating document $e"),
    );
  }

  Future adminPanelDelete(Map<String,List<String>> deletedItems)async{
    for(var element in deletedItems.keys){
      if(deletedItems[element]!=[]){
        for(var deletedItem in deletedItems[element]!){
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            var siparisler=await _siparislerQuery.get();
            var itemTable=await FirebaseFirestore.instance.collection("${element.capitalize()}Names").where("name",isEqualTo:deletedItem).orderBy("id").get();
            var allItemTable=await FirebaseFirestore.instance.collection("${element.capitalize()}Names").orderBy("id").get();
            var stok=await FirebaseFirestore.instance.collection("Stok").get();

            for (var siparis in siparisler.docs) {
              if(siparis.data()["tableValues"][element]==(itemTable.docs.first["id"] as int)){
                transaction.delete(_siparislerQuery.doc(siparis.id));
              }
              else if(siparis.data()["tableValues"][element] > (itemTable.docs.first["id"]as int)){
                transaction.update(_siparislerQuery.doc(siparis.id), {"tableValues.$element":FieldValue.increment(-1)});
              }
            }
            for(var stok in stok.docs){
              if(stok.data()["tableValues"][element]==(itemTable.docs.first["id"] as int)){
                transaction.delete(FirebaseFirestore.instance.collection("Stok").doc(stok.id));
              }
              else if(stok.data()["tableValues"][element] > (itemTable.docs.first["id"]as int)){
                transaction.update(FirebaseFirestore.instance.collection("Stok").doc(stok.id), {"tableValues.$element":FieldValue.increment(-1)});
              }

            }
            for(var item in allItemTable.docs){
              if(item.data()["id"]==itemTable.docs.first["id"]){
                transaction.delete(FirebaseFirestore.instance.collection("${element.capitalize()}Names").doc(item.id));
              }
            }
            for(var item in allItemTable.docs){
              if(item.data()["id"]>itemTable.docs.first["id"]){
                transaction.delete(FirebaseFirestore.instance.collection("${element.capitalize()}Names").doc(item.id));
                var newId=int.parse(item.id);
                newId--;
                var newData=item.data();
                newData["id"]=newId;
                transaction.set(FirebaseFirestore.instance.collection("${element.capitalize()}Names").doc(newId.toString()), newData);
              }
            }
          }).then(
                (value) => print(""),
            onError: (e) => print("Error updating document $e"),
          );

        }
      }
    }

  }

  bool first=false;
  int removecounter=0;
  Future adminPanelAddItem(Map<String,List<String>> addedItems)async{
    for(var key in addedItems.keys){
      if(addedItems[key]!=[]){
        for(var addedItem in addedItems[key]!){
          Map<String, dynamic> selectedTable=CustomText.tableHierarchy.firstWhere((e) => e["tableValueName"]==key);
          List<int> listLength=[];
          for(var tableOrder in CustomText.tableHierarchy){
            if(tableOrder!=selectedTable){
              listLength.add(CustomText.allTablesString[tableOrder["tableName"]]!.length);
            }
          }
          List<int> newStokIds=[];
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            var allItemTable=await FirebaseFirestore.instance.collection("${key.capitalize()}Names").orderBy("id").get();
            int lastId = allItemTable.docs.last["id"] as int;
            lastId++;
            transaction.set(FirebaseFirestore.instance.collection("${key.capitalize()}Names").doc(lastId.toString()), {"name":addedItem,"id":lastId});
            removecounter=0;
            first=false;
            recursiveStokAddItem(0,listLength.length-1,newStokIds,transaction,lastId,selectedTable,listLength);
          }).then(
                (value) => print(""),
            onError: (e) => print("Error updating document $e"),
          );

          CustomText.tableHierarchy=await getTableHierarchy();
          for(var element in CustomText.tableHierarchy){
            CustomText.allTablesString[element["tableName"]]=await getTableValues("${element["tableValueName"]}".capitalize());
          }
        }
      }
    }
  }
  recursiveStokAddItem(int derinlik,int ilkderinlik,List<int> newStokIds,
      Transaction transaction,int newId,Map<String, dynamic> selectedTable,
      List<int>listLength,
      ){
    if(derinlik>ilkderinlik){
      if(first){
        print(removecounter);
        newStokIds.removeRange(ilkderinlik-removecounter+1,ilkderinlik+1);
        newStokIds.insert(selectedTable["id"]as int, newId);
        var ref=FirebaseFirestore.instance.collection("Stok").doc();
        transaction.set(ref, {"id":ref.id,"stok":10,"tableValues":{for(int i=0;i<CustomText.tableHierarchy.length;i++) CustomText.tableHierarchy[i]["tableValueName"] : newStokIds[i]}});
        print(newStokIds);
        newStokIds.removeAt(selectedTable["id"]as int);
        removecounter=0;
      }else{
        first=!first;
        newStokIds.insert(selectedTable["id"]as int, newId);
        var ref=FirebaseFirestore.instance.collection("Stok").doc();
        transaction.set(ref, {"id":ref.id,"stok":10,"tableValues":{for(int i=0;i<CustomText.tableHierarchy.length;i++) CustomText.tableHierarchy[i]["tableValueName"] : newStokIds[i]}});
        print(newStokIds);
        newStokIds.removeAt(selectedTable["id"]as int);
        removecounter=0;
      }

    }else{
      for(int i=0;i<listLength[derinlik];i++){
        newStokIds.add(i);
        removecounter++;
        recursiveStokAddItem(derinlik+1,ilkderinlik,newStokIds,transaction,newId,selectedTable,listLength);
      }

    }
  }

  Future adminPanelUpdateItem(Map<String,List<Map<String,String>>> updatedItems)async{
    for(var key in updatedItems.keys){
      if(updatedItems[key]!=[]){
        for(Map<String, String> updatedItem in updatedItems[key]!){
          var aktif=CustomText.tableHierarchy.firstWhere((element) => element["tableValueName"]==key);
          int index=CustomText.allTablesString[aktif["tableName"]]!.indexWhere((element) => element==updatedItem["old"]);
          await FirebaseFirestore.instance.collection("${key.capitalize()}Names").doc(index.toString()).update({"name":updatedItem["new"]});
        }
      }
    }
  }

  Future changeStatusSiparis(Siparisler siparis)async{
    bool first=true;
    await FirebaseFirestore.instance.runTransaction((transaction) async{

      var refStokCount;
      for(var element in CustomText.tableHierarchy){
        if(first){
           refStokCount=FirebaseFirestore.instance.collection("Stok").where("tableValues.${element["tableValueName"]}",isEqualTo: siparis.tableValues![element["tableValueName"]]);
          first=!first;
        }else{
          refStokCount=refStokCount.where("tableValues.${element["tableValueName"]}",isEqualTo: siparis.tableValues![element["tableValueName"]]);
        }
      }
      var data = await refStokCount.get();
      var ref=FirebaseFirestore.instance.collection("Stok").doc(data.docs.first.data()["id"]);
      if(siparis.isDone){
        int value=-siparis.adet!+siparis.partialOrder!;
        transaction.update(ref, {"stok":FieldValue.increment(value)});
      }
      else{
        transaction.update(ref, {"stok":FieldValue.increment(siparis.adet!)});
      }
      if(siparis.isDone){
        siparis.partialOrder=siparis.adet;
      }else{
        siparis.partialOrder=0;
      }
      transaction.update(_siparislerQuery.doc(siparis.id), siparis.toJson());
    });
  }
  Future changeStatusPartialOrderSiparis(Siparisler siparis,bool isInc)async{
    bool first=true;
    await FirebaseFirestore.instance.runTransaction((transaction) async{
      transaction.update(_siparislerQuery.doc(siparis.id), siparis.toJson());
      var refStokCount;
      for(var element in CustomText.tableHierarchy){
        if(first){
          refStokCount=FirebaseFirestore.instance.collection("Stok").where("tableValues.${element["tableValueName"]}",isEqualTo: siparis.tableValues![element["tableValueName"]]);
          first=!first;
        }else{
          refStokCount=refStokCount.where("tableValues.${element["tableValueName"]}",isEqualTo: siparis.tableValues![element["tableValueName"]]);
        }
      }
      var data = await refStokCount.get();
      var ref=FirebaseFirestore.instance.collection("Stok").doc(data.docs.first.data()["id"]);
      if(isInc){
        transaction.update(ref, {"stok":FieldValue.increment(-1)});
      }
      else{
        transaction.update(ref, {"stok":FieldValue.increment(1)});
      }
    });
  }
  updateSiparis(Siparisler siparis)async{
    try{
      await _siparislerQuery.doc(siparis.id)
          .update(siparis.toJson());
    }catch(e){
      rethrow;
    }
  }


  Future saveMusteri(Musteriler musteri) async {
    final ref =_musterilerQuery.doc();
    musteri.id = ref.id;
    musteri.date=DateTime.now().millisecondsSinceEpoch;
    final json = musteri.toJson();
    print(musteri.id);
    await ref.set(json);
  }
  Future updateMusteri(Musteriler musteri) async {
    try{
      await _musterilerQuery.doc(musteri.id!).update(musteri.toJson());
    }catch(e){
      rethrow;
    }
  }

  Future saveSiparis(
      List<Siparisler> siparisler, String musteriId) async {
    final batch = FirebaseFirestore.instance.batch();
    siparisler.forEach((siparis) {
      final ref = _siparislerQuery.doc();
      siparis.id = ref.id;
      siparis.musteriId=musteriId;
      siparis.date=DateTime.now().millisecondsSinceEpoch;
      siparis.kaydeden=UserModel.instance.name;
      final json = siparis.toJson();
      batch.set(ref, json);
    });
    await batch.commit();
  }

  Future<List<Musteriler>> getMusteriler()async{
    var ref= await _musterilerQuery.orderBy("date",descending: true).get();
    return ref.docs.map((musteri) => Musteriler.fromJson(musteri.data())).toList();
  }

  Future<Musteriler> getMusteriById(String id)async{
    var ref= await _musterilerQuery.doc(id).get();
    return Musteriler.fromJson(ref.data()!);
  }

  deleteMusteri(Musteriler musteri)async{
    final musteriRef= _musterilerQuery.doc(musteri.id);
    final batch = FirebaseFirestore.instance.batch();
    try{
      var siparislerRef=await _siparislerQuery.where("musteriId",isEqualTo: musteri.id).get();
      for (var siparis in siparislerRef.docs) {
        batch.delete(siparis.reference);
      }
      batch.delete(musteriRef);
      await batch.commit();
    }catch(e){
      log(e.toString());
      throw("Hata müsteri silinemedi");
    }
  }
  Future deleteCollectionRecursive(String path)async{
    try {
       var result = await FirebaseFunctions.instance.httpsCallable('recursiveDelete').call(
        {
          "path":"Subeler/2/Cesitler/5",
        }
      );
    } on FirebaseFunctionsException catch (error) {
      print(error.code);
      print(error.details);
      print(error.message);
    }
  }

  Future<List<Map<String,dynamic>>> getTableHierarchy()async{
    List<Map<String,dynamic>> list=[];
    final ref=FirebaseFirestore.instance.collection("TableHierarchy");
    var data = await ref.get();
    for (var element in data.docs) {
      list.add({"id":element["id"],"tableName":element["tableName"],"tableValueName":element["tableValueName"]});
    }
    return list;
  }
}
