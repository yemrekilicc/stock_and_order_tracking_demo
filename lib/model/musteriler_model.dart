import 'dart:convert';

import 'package:siparis_takip_demo/model/siparisler_model.dart';

Musteriler musterilerFromJson(String str) => Musteriler.fromJson(json.decode(str));

String musterilerToJson(Musteriler data) => json.encode(data.toJson());

class Musteriler {
  Musteriler({
    this.id,
    required this.adi,
    this.telefon="",
    this.aciklama="",
    this.adres="",
    this.date,
  });
  String adres;
  String? id;
  String adi;
  String telefon;
  String aciklama;
  int? date;

  factory Musteriler.fromJson(Map<String, dynamic> json) => Musteriler(
    id: json["id"],
    adi: json["adi"],
    telefon: json["telefon"],
    aciklama: json["aciklama"],
    adres: json["adres"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id":id,
    "adi": adi,
    "telefon": telefon,
    "aciklama": aciklama,
    "adres": adres,
    "date":date
  };
}