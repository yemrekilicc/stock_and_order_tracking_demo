import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siparis_takip_demo/core/init/firebase/query.dart';
import 'package:siparis_takip_demo/model/musteriler_model.dart';

import '../../../core/base/base_viewmodel/base_viewmodel.dart';

class AddContactViewModel extends BaseViewModel{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController isimController =TextEditingController();
  TextEditingController telefonController =TextEditingController();
  TextEditingController adresController =TextEditingController();
  TextEditingController notController =TextEditingController();
  Musteriler? musteri;
  bool isUpdate=false;
  @override
  FutureOr<void> init({Map<String,dynamic>? musteri}) {
    if (!isInitialized) {
      isInitialized = !isInitialized;
      changeStatus();
    }
    if(musteri!=null){
      isimController.text=musteri["musteri"].adi;
      telefonController.text=musteri["musteri"].telefon;
      adresController.text=musteri["musteri"].adres;
      notController.text=musteri["musteri"].aciklama;
      isUpdate=musteri["isUpdate"];
      if(isUpdate){
        this.musteri=musteri["musteri"];
      }
    }
  }
  Future <void>addContact()async{
    musteri=Musteriler(
      adi: isimController.value.text,
      telefon: telefonController.value.text,
      adres: adresController.value.text,
      aciklama: notController.value.text,
    );
    Querys.instance.saveMusteri(musteri!);
  }

  Future updateContact()async{
    musteri!.adi=isimController.value.text;
    musteri!.telefon=telefonController.value.text;
    musteri!.adres=adresController.value.text;
    musteri!.aciklama=notController.value.text;
    musteri!.date=DateTime.now().millisecondsSinceEpoch;
    await Querys.instance.updateMusteri(musteri!);
  }

  @override
  void setContext(BuildContext context) {
  }
}