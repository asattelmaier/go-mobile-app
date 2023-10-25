import 'dart:developer' as developer;

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<String?> get(String value) async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();

      return sharedPreferences.getString(value);
    } catch (error) {
      developer.log('Error during local storage read: $error', error: error);
      return null;
    }
  }

  Future<void> set(String key, String value) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString(key, value);
  }

  Future<void> remove(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.remove(key);
  }
}
