import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyChain {
  final _storage = const FlutterSecureStorage();

  KeyChain() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<String?> get(String value) async {
    try {
      return await _storage.read(key: value);
    } catch (error) {
      developer.log('Error during key chain get: $error', error: error);
      return null;
    }
  }

  Future<void> set(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (error) {
      developer.log('Error during key chain put: $error', error: error);
    }
  }

  Future<void> remove(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (error) {
      developer.log('Error during key chain remove: $error', error: error);
    }
  }
}
