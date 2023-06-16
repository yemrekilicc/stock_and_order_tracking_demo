// To parse this JSON data, do
//
//     final subeler = subelerFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Subeler subelerFromJson(String str) => Subeler.fromJson(json.decode(str));

String subelerToJson(Subeler data) => json.encode(data.toJson());

class Subeler {
  Subeler({
    required this.the0,
    required this.the1,
    required this.the2,
    required this.the3,
    required this.the4,
    required this.the5,
    required this.id,
  });

  int the0;
  int the1;
  int the2;
  int the3;
  int the4;
  int the5;
  String id;

  factory Subeler.fromJson(Map<String, dynamic> json) => Subeler(
    the0: json["0"],
    the1: json["1"],
    the2: json["2"],
    the3: json["3"],
    the4: json["4"],
    the5: json["5"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "0": the0,
    "1": the1,
    "2": the2,
    "3": the3,
    "4": the4,
    "5": the5,
    "id": id,
  };
}
