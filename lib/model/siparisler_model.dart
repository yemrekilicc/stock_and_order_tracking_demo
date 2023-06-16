import 'dart:convert';

import 'package:siparis_takip_demo/core/constants/text_constants.dart';

List<Siparisler> siparislerFromJson(String str) => List<Siparisler>.from(json.decode(str).map((x) => Siparisler.fromJson(x)));

String siparislerToJson(List<Siparisler> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Siparisler {
  Siparisler({
    this.id,
    this.adet,
    // this.cesit,
    this.not,
    // this.ebat,
    // this.teslimatSube,
    this.kaydeden="",
    this.date,
    this.isDone=false,
    this.musteriId,
    this.musteriName,
    this.tableValues,
    this.partialOrder,
  });

  String? id;
  int? adet;
  // int? cesit;
  String? not;
  // int? ebat;
  // int? teslimatSube;
  String? kaydeden;
  bool isDone;
  int? date;
  int? partialOrder;
  String? musteriId;
  String? musteriName;
  Map<String,int>? tableValues;


  factory Siparisler.fromJson(Map<String, dynamic> json) => Siparisler(
    id: json["id"],
    adet: json["adet"],
    //cesit: json["cesit"],
    not: json["not"],
    //ebat: json["ebat"],
    tableValues: {for(var e in CustomText.tableHierarchy) e["tableValueName"] : json["tableValues"][e["tableValueName"]]},
    //teslimatSube: json["sube"],
    kaydeden: json["kaydeden"],
    isDone: json["isDone"],
    date: json["date"],
    musteriId: json["musteriId"],
    partialOrder: json["partialOrder"]??=0
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "adet": adet,
    //"cesit": cesit,
    "not": not,
    //"ebat": ebat,
    //"sube": teslimatSube,
    "tableValues": {for(var e in CustomText.tableHierarchy) e["tableValueName"] : tableValues![e["tableValueName"]]},
    "kaydeden":kaydeden,
    "isDone": isDone,
    "date":date,
    "musteriId":musteriId,
    "partialOrder":partialOrder,
  };
}
