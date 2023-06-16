
import 'dart:convert';

UserModel userFromJson(String str) => UserModel.fromJson(json.decode(str));

String userToJson(UserModel data) => json.encode(data.toJson());


class UserModel {
  static final UserModel _instance = UserModel._init();
  static UserModel get instance => _instance;
  UserModel._init();

  late String uid;
  late bool isAdmin;
  late String name;
  late String email;

  factory UserModel({required String uid,required String name,required String email,required bool isAdmin}){
    _instance.uid=uid;
    _instance.name=name;
    _instance.email=email;
    _instance.isAdmin=isAdmin;
    return _instance;
}

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json["uid"],
    name: json["name"],
    email: json["email"],
    isAdmin: json["isAdmin"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "email": email,
    "isAdmin": isAdmin,
  };
}

