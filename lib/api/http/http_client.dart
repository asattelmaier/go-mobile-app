import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpClient {
  final Uri _baseUrl;

  HttpClient(this._baseUrl);

  Future<T> get<T>(String path) async {
    final response = await http.get(_baseUrl.replace(path: path));

    return json.decode(response.body);
  }

  Future<T> post<T>(String path, [Object? data]) async {
    final response = await http.post(_baseUrl.replace(path: path), body: data);

    return json.decode(response.body);
  }
}
