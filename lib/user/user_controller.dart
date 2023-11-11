import 'dart:developer' as developer;

import 'package:go_app/api/http/http_client.dart';
import 'package:go_app/api/http_headers/http_headers_builder.dart';
import 'package:go_app/api/key_chain/key_chain.dart';
import 'package:go_app/user/input/tokens_dto.dart';
import 'package:go_app/user/input/user_dto.dart';
import 'package:go_app/user/tokens_model.dart';
import 'package:go_app/user/user_model.dart';

class UserController {
  static const _KEY_CHAIN_REFRESH_TOKEN_KEY = "refresh-token";
  static const _KEY_CHAIN_ACCESS_TOKEN_KEY = "access-token";
  final KeyChain _keyChain;
  final HttpClient _httpClient;
  TokensModel _tokens;
  UserModel _user;

  UserController._(this._keyChain, this._httpClient, this._tokens, this._user);

  static Future<UserController> create(
      KeyChain keyChain, HttpClient httpClient) async {
    final accessToken = await keyChain.get(_KEY_CHAIN_ACCESS_TOKEN_KEY);
    final refreshToken = await keyChain.get(_KEY_CHAIN_REFRESH_TOKEN_KEY);

    if (accessToken != null && refreshToken != null) {
      final tokens = TokensModel(refreshToken, accessToken);

      return _createWithUser(httpClient, keyChain, tokens);
    }

    return UserController._(
        keyChain, httpClient, TokensModel.empty(), UserModel.empty());
  }

  bool get isUserLoggedIn => !_user.isEmpty;

  UserModel get user => _user;

  String get accessToken => _tokens.accessToken;

  Future<UserModel> createGuestUser() async {
    if (isUserLoggedIn) {
      return _user;
    }

    try {
      final response = await _httpClient.post("/auth/register/guest");
      final tokens = TokensModel.fromDto(TokensDto.fromJson(response));

      await _keyChain.set(_KEY_CHAIN_ACCESS_TOKEN_KEY, tokens.accessToken);
      await _keyChain.set(_KEY_CHAIN_REFRESH_TOKEN_KEY, tokens.refreshToken);
      _tokens = tokens;
      _user = await _requestUser(_httpClient, tokens);

      return _user;
    } catch (error) {
      developer.log("Error during guest user creation: $error", error: error);

      return UserModel.empty();
    }
  }

  static Future<UserController> _createWithUser(
      HttpClient httpClient, KeyChain localStorage, TokensModel tokens) async {
    final user = await _requestUser(httpClient, tokens);

    if (user.isEmpty) {
      await localStorage.remove(_KEY_CHAIN_ACCESS_TOKEN_KEY);
      await localStorage.remove(_KEY_CHAIN_REFRESH_TOKEN_KEY);
    }

    return UserController._(localStorage, httpClient, tokens, user);
  }

  static Future<UserModel> _requestUser(
      HttpClient httpClient, TokensModel tokens) async {
    try {
      final accessToken = tokens.accessToken;
      final authorizationHeader = HttpHeadersBuilder.token(accessToken).build();
      final response = await httpClient.get("/user", authorizationHeader);

      return UserModel.fromDto(UserDto.fromJson(response));
    } catch (error) {
      developer.log("Error during user request: $error", error: error);

      return UserModel.empty();
    }
  }
}
