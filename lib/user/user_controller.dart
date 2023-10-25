import 'package:go_app/api/http/http_client.dart';
import 'package:go_app/api/local_storage/local_storage.dart';
import 'package:go_app/user/input/user_dto.dart';
import 'package:go_app/user/user_model.dart';
import 'dart:developer' as developer;

class UserController {
  static const _LOCAL_STORAGE_USER_ID_KEY = "user-id";
  final LocalStorage _localStorage;
  final HttpClient _httpClient;
  UserModel _user;

  UserController._(this._localStorage, this._httpClient, this._user);

  static Future<UserController> create(
      LocalStorage localStorage, HttpClient httpClient) async {
    final userId = await localStorage.get(_LOCAL_STORAGE_USER_ID_KEY);

    if (userId != null) {
      return _createWithUser(httpClient, localStorage, userId);
    }

    return UserController._(localStorage, httpClient, UserModel.empty());
  }

  bool get hasUser => !_user.isEmpty;

  UserModel get user => _user;

  Future<UserModel> createGuestUser() async {
    if (hasUser) {
      return _user;
    }

    try {
      final response = await _httpClient.post("/user/guest");

      _user = UserModel.fromDto(UserDto.fromJson(response));
      await _localStorage.set(_LOCAL_STORAGE_USER_ID_KEY, _user.id);

      return _user;
    } catch (error) {
      developer.log("Error during guest user creation: $error", error: error);

      return UserModel.empty();
    }
  }

  static Future<UserController> _createWithUser(
      HttpClient httpClient, LocalStorage localStorage, String userId) async {
    final user = await _requestUser(httpClient, userId);

    if (user.isEmpty) {
      await localStorage.remove(_LOCAL_STORAGE_USER_ID_KEY);
    }

    return UserController._(localStorage, httpClient, user);
  }

  static Future<UserModel> _requestUser(
      HttpClient httpClient, String userId) async {
    try {
      final response = await httpClient.get("/user/$userId");

      return UserModel.fromDto(UserDto.fromJson(response));
    } catch (error) {
      developer.log("Error during user request: $error", error: error);

      return UserModel.empty();
    }
  }
}
