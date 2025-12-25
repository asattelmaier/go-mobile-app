import 'dart:developer' as developer;

import 'package:go_app/api/key_chain/key_chain.dart';
import 'package:go_app/user/tokens_model.dart';
import 'package:go_app/user/user_model.dart';
import 'package:session_server_client/api.dart';

class UserController {
  static const _KEY_CHAIN_REFRESH_TOKEN_KEY = "refresh-token";
  static const _KEY_CHAIN_ACCESS_TOKEN_KEY = "access-token";
  
  // Persistent Guest Tokens
  static const _KEY_CHAIN_GUEST_REFRESH_TOKEN_KEY = "guest-refresh-token";
  static const _KEY_CHAIN_GUEST_ACCESS_TOKEN_KEY = "guest-access-token";

  final KeyChain _keyChain;
  final ApiClient _apiClient;
  TokensModel _tokens;
  UserModel _user;

  UserController._(this._keyChain, this._apiClient, this._tokens, this._user);

  static Future<UserController> create(
      KeyChain keyChain, ApiClient apiClient) async {
    final accessToken = await keyChain.get(_KEY_CHAIN_ACCESS_TOKEN_KEY);
    final refreshToken = await keyChain.get(_KEY_CHAIN_REFRESH_TOKEN_KEY);

    if (accessToken != null && refreshToken != null) {
      final tokens = TokensModel(refreshToken, accessToken);
      // Pre-configure the client with the token
      apiClient.addDefaultHeader('Authorization', 'Bearer $accessToken');
      
      return _createWithUser(apiClient, keyChain, tokens);
    }

    return UserController._(
        keyChain, apiClient, TokensModel.empty(), UserModel.empty());
  }

  bool get isUserLoggedIn => !_user.isEmpty;

  UserModel get user => _user;

  String get accessToken => _tokens.accessToken;

  Future<UserModel> createGuestUser() async {
    if (isUserLoggedIn) {
      return _user;
    }

    // 1. Try to reuse existing guest
    final guestAccess = await _keyChain.get(_KEY_CHAIN_GUEST_ACCESS_TOKEN_KEY);
    final guestRefresh = await _keyChain.get(_KEY_CHAIN_GUEST_REFRESH_TOKEN_KEY);

    if (guestAccess != null && guestRefresh != null) {
      final guestTokens = TokensModel(guestRefresh, guestAccess);
      
      // Temporarily set token to verify user
      _apiClient.addDefaultHeader('Authorization', 'Bearer $guestAccess');
      final guestUser = await _requestUser(_apiClient);
      
      if (!guestUser.isEmpty) {
         // Found valid existing guest! Use it.
         await _keyChain.set(_KEY_CHAIN_ACCESS_TOKEN_KEY, guestTokens.accessToken);
         await _keyChain.set(_KEY_CHAIN_REFRESH_TOKEN_KEY, guestTokens.refreshToken); 
         _tokens = guestTokens;
         _user = guestUser;
         return _user;
      } else {
         // Invalid guest token, clear header
         _apiClient.defaultHeaderMap.remove('Authorization');
      }
    }

    // 2. Otherwise create new guest
    try {
      final authApi = AuthenticationControllerApi(_apiClient);
      final response = await authApi.registerGuest();
      
      if (response == null) throw Exception("Empty response from registerGuest");

      final tokens = TokensModel.fromDto(response);

      // Make active
      await _keyChain.set(_KEY_CHAIN_ACCESS_TOKEN_KEY, tokens.accessToken);
      await _keyChain.set(_KEY_CHAIN_REFRESH_TOKEN_KEY, tokens.refreshToken);
      
      // Persist as Guest (redundant backup for future reuse)
      await _keyChain.set(_KEY_CHAIN_GUEST_ACCESS_TOKEN_KEY, tokens.accessToken);
      await _keyChain.set(_KEY_CHAIN_GUEST_REFRESH_TOKEN_KEY, tokens.refreshToken);

      _apiClient.addDefaultHeader('Authorization', 'Bearer ${tokens.accessToken}');
      
      _tokens = tokens;
      _user = await _requestUser(_apiClient);

      return _user;
    } catch (error) {
      developer.log("Error during guest user creation: $error", error: error);
      return UserModel.empty();
    }
  }

  static Future<UserController> _createWithUser(
      ApiClient apiClient, KeyChain localStorage, TokensModel tokens) async {
    final user = await _requestUser(apiClient);

    if (user.isEmpty) {
      await localStorage.remove(_KEY_CHAIN_ACCESS_TOKEN_KEY);
      await localStorage.remove(_KEY_CHAIN_REFRESH_TOKEN_KEY);
      apiClient.defaultHeaderMap.remove('Authorization');
    }

    return UserController._(localStorage, apiClient, tokens, user);
  }

  static Future<UserModel> _requestUser(ApiClient apiClient) async {
    try {
      final userApi = UserControllerApi(apiClient);
      final response = await userApi.getUser();
      
      if (response == null) return UserModel.empty();

      return UserModel.fromDto(response);
    } catch (error) {
      developer.log("Error during user request: $error", error: error);
      return UserModel.empty();
    }
  }
  Future<void> clearSession() async {
    await _keyChain.remove(_KEY_CHAIN_ACCESS_TOKEN_KEY);
    await _keyChain.remove(_KEY_CHAIN_REFRESH_TOKEN_KEY);
    await _keyChain.remove(_KEY_CHAIN_GUEST_ACCESS_TOKEN_KEY);
    await _keyChain.remove(_KEY_CHAIN_GUEST_REFRESH_TOKEN_KEY);
    _tokens = TokensModel.empty();
    _user = UserModel.empty();
    _apiClient.defaultHeaderMap.remove('Authorization');
  }
}
