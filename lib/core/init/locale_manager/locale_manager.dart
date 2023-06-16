// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class LocaleManager {
//   static final LocaleManager _instance = LocaleManager._init();
//
//   FlutterSecureStorage? _storage;
//
//   static LocaleManager get instance => _instance;
//   LocaleManager._init();
//   static Future prefrencesInit() async {
//     instance._storage ??= const FlutterSecureStorage();
//     return;
//   }
//
//   Future<void> setStringValue(String key, String value) async {
//     await _storage!.write(key: key, value: value);
//   }
//
//   Future<void> setBoolValue(String key, bool? value) async {
//     await _storage!.write(key: key, value: value.toString());
//   }
//
//   Future<void> setIntValue(String key, int value) async {
//     await _storage!.write(key: key, value: value.toString());
//   }
//
//   Future<void> deleteKey(String key) async {
//     await _storage!.delete(key: key);
//   }
//
//   Future<void> deleteAllKeys() async {
//     await _storage!.deleteAll();
//   }
//
//   Future<int> getIntValue(String key) async =>
//       int.parse((await _storage!.read(key: key) ?? "0"));
//
//   Future<String> getStringValue(String key) async =>
//       await _storage!.read(key: key) ?? "0";
//
//   Future<bool> getBoolValue(String key) async =>
//       await _storage!.read(key: key) == null ? false : true;
// }
