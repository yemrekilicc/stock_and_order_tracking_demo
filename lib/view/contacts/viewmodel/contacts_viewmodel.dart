import 'dart:async';

import 'package:siparis_takip_demo/core/constants/navigation_constant.dart';
import 'package:siparis_takip_demo/core/init/firebase/query.dart';
import 'package:siparis_takip_demo/model/musteriler_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/base/base_viewmodel/base_viewmodel.dart';

class ContactsViewModel extends BaseViewModel {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  int popUpMenuValue = 0;
  AsyncSnapshot<List<Musteriler>> lastSnapshot = const AsyncSnapshot.nothing();
  List<Musteriler> musterilerSuggestion = [];
  List<Musteriler> orjList = [];
  late Future<List<Musteriler>> musteriler;
  @override
  FutureOr<void> init() {
    if (!isInitialized) {
      isInitialized = !isInitialized;
      changeStatus();
    }
    musteriler = Querys.instance.getMusteriler();
  }
  // setData(){
  //   musteriler = Querys.instance.getMusteriler();
  //   notifyListeners();
  // }
  Future reloadMusteriler() async {
    musteriler = Querys.instance.getMusteriler();
    await sortAndFilter();
  }

  sortAndFilter() async {
    musterilerSuggestion = List.of(await musteriler);
    musterilerSuggestion.retainWhere((element) {
      final inputLower = searchController.text.toLowerCase();
      final patternLower = element.adi.toLowerCase();
      return patternLower.contains(inputLower);
    });
    // if(isDescending){
    //   musterilerveSiparislerSuggestion.sort((b, a) => a.date!.compareTo(b.date!));
    // }
    // else{
    //   musterilerveSiparislerSuggestion.sort((a, b) => a.date!.compareTo(b.date!));
    // }
    // if(isDone!=-1){
    //   musterilerveSiparislerSuggestion.retainWhere((element) => element.isDone==(isDone==1?true:false));
    // }
    // if(whichSube!=-1){
    //   musterilerveSiparislerSuggestion.retainWhere((element) => element.teslimatSube==whichSube);
    // }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> deleteMusteri(Musteriler musteri,BuildContext context) async {
    try{
      await Querys.instance.deleteMusteri(musteri);
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "HATA: $e",
          ),
        ),
      );
    }
    await reloadMusteriler();
  }

  popUpAction(int value, int index, BuildContext context) {
    popUpMenuValue = value;
    if(value==0){
      navigation.navigateToPage(
        path: NavigationConstants.ADDCONTACT,
        data: {"musteri":musterilerSuggestion[index],"isUpdate":true},
      ).then((value) => notifyListeners());
    }
    else if(value==1){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          buttonPadding: EdgeInsets.zero,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("İPTAL"),
            ),
            TextButton(
                onPressed: () async {
                  await deleteMusteri(musterilerSuggestion[index],context).then((value){
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Kayıt silindi",
                        ),
                      ),
                    );
                  }).catchError(
                        // ignore: invalid_return_type_for_catch_error
                        (error) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "HATA: $error",
                        ),
                      ),
                    ),
                  );
                },
                child: const Text("SİL"))
          ],
          content: const Text("Müşteri kaydı silinsin mi?"),
        ),
      );
    }
    notifyListeners();
  }

  @override
  void setContext(BuildContext context) {}
}
