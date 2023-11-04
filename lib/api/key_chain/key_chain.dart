import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:flutter_keychain/flutter_keychain.dart';

class KeyChain {
  KeyChain() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<String?> get(String value) async {
    try {
      return await FlutterKeychain.get(key: value);
    } catch (error) {
      developer.log('Error during key chain get: $error', error: error);
      return null;
    }
  }

  Future<void> set(String key, String value) async {
    try {
      await FlutterKeychain.put(key: key, value: value);
    } catch (error) {
      developer.log('Error during key chain put: $error', error: error);
    }
  }

  Future<void> remove(String key) async {
    try {
      await FlutterKeychain.remove(key: key);
    } catch (error) {
      developer.log('Error during key chain remove: $error', error: error);
    }
  }
}
