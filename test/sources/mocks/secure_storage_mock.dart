import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

/// Extends [FlutterSecureStorage] and mocks each functionality so that
/// this class can be used inside unit tests too.
class MockSecureStorage extends FlutterSecureStorage {
  static Map<String, String> _valuesMap = {};

  @override
  Future<Function> write({
    @required String key,
    @required String value,
    iOSOptions iOptions,
    AndroidOptions aOptions,
  }) async {
    _valuesMap[key] = value;
  }

  @override
  Future<Function> deleteAll({iOSOptions iOptions, AndroidOptions aOptions}) {
    _valuesMap.clear();
  }

  @override
  Future<Map<String, String>> readAll({
    iOSOptions iOptions,
    AndroidOptions aOptions,
  }) async {
    return _valuesMap;
  }

  @override
  Future<Function> delete({
    @required String key,
    iOSOptions iOptions,
    AndroidOptions aOptions,
  }) async {
    _valuesMap[key] = null;
  }

  @override
  Future<String> read({
    @required String key,
    iOSOptions iOptions,
    AndroidOptions aOptions,
  }) async {
    return _valuesMap[key];
  }
}
