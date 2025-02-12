import 'package:flutter/material.dart';
import 'backend/backend.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    secureStorage = const FlutterSecureStorage();
    _OPENAIAPIKEY =
        await secureStorage.getString('sk-proj-QzTCw0Teb9GDIJ7cnlzbT3BlbkFJkG5e2o2IoxUG1QcEmvLR') ?? _OPENAIAPIKEY;
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  String _OPENAIAPIKEY = 'sk-proj-QzTCw0Teb9GDIJ7cnlzbT3BlbkFJkG5e2o2IoxUG1QcEmvLR';
  String get OPENAIAPIKEY => _OPENAIAPIKEY;
  set OPENAIAPIKEY(String value) {
    _OPENAIAPIKEY = value;
    secureStorage.setString('sk-proj-QzTCw0Teb9GDIJ7cnlzbT3BlbkFJkG5e2o2IoxUG1QcEmvLR', value);
  }

  void deleteOPENAIAPIKEY() {
    secureStorage.delete(key: 'sk-proj-QzTCw0Teb9GDIJ7cnlzbT3BlbkFJkG5e2o2IoxUG1QcEmvLR');
  }
}

// ignore: unused_element
LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await write(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await write(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await write(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await write(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return const CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await write(key: key, value: const ListToCsvConverter().convert([value]));
}
