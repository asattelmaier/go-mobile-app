import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:session_server_client/api.dart';
import 'package:go_app/api/key_chain/key_chain.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_controller_test.mocks.dart';

@GenerateMocks([KeyChain, Client])
void main() {
  group("create", () {
    test("creates an empty user if no tokens are stored", () async {
      final keyChain = MockKeyChain();
      final mockClient = MockClient();
      final apiClient = ApiClient()..client = mockClient;

      when(keyChain.get("access-token")).thenAnswer((_) async => null);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => null);
      final userController = await UserController.create(keyChain, apiClient);

      expect(userController.user.isEmpty, isTrue);
    });

    test("creates a user if tokens are stored", () async {
      final keyChain = MockKeyChain();
      final mockClient = MockClient();
      final apiClient = ApiClient()..client = mockClient;
      final accessToken = "some-token";
      final refreshToken = "some-other-token";
      final userJson = jsonEncode({"id": "some-id", "username": "some-name"});

      when(keyChain.get("access-token")).thenAnswer((_) async => accessToken);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => refreshToken);
      
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => 
        Response(userJson, 200, headers: {'content-type': 'application/json'})
      );

      final userController = await UserController.create(keyChain, apiClient);

      expect(userController.user.id, equals("some-id"));
    });

    test("creates an empty user if user request fails", () async {
      final keyChain = MockKeyChain();
      final mockClient = MockClient();
      final apiClient = ApiClient()..client = mockClient;
      final accessToken = "some-token";
      final refreshToken = "some-other-token";

      when(keyChain.get("access-token")).thenAnswer((_) async => accessToken);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => refreshToken);
      
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => 
        Response("Error", 500)
      );

      final userController = await UserController.create(keyChain, apiClient);

      expect(userController.user.isEmpty, isTrue);
    });

    test("removes user from storage if the user request fails", () async {
      final keyChain = MockKeyChain();
      final mockClient = MockClient();
      final apiClient = ApiClient()..client = mockClient;
      final accessToken = "some-token";
      final refreshToken = "some-other-token";

      when(keyChain.get("access-token")).thenAnswer((_) async => accessToken);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => refreshToken);
      
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => 
        Response("Error", 500)
      );
      
      await UserController.create(keyChain, apiClient);

      verify(keyChain.remove("access-token"));
      verify(keyChain.remove("refresh-token"));
    });
  });

  group("createGuestUser", () {
    test("creates a guest user", () async {
      final keyChain = MockKeyChain();
      final mockClient = MockClient();
      final apiClient = ApiClient()..client = mockClient;
      final accessToken = "some-token";
      final tokensJson = jsonEncode({
        "refreshToken": "some-other-token",
        "accessToken": accessToken,
      });
      final userJson = jsonEncode({"id": "some-id", "username": "some-name"});

      when(keyChain.get("access-token")).thenAnswer((_) async => null);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => null);
      when(keyChain.get("guest-access-token")).thenAnswer((_) async => null);
      when(keyChain.get("guest-refresh-token")).thenAnswer((_) async => null);

      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((invocation) async {
         return Response(userJson, 200, headers: {'content-type': 'application/json'});
      });

      when(mockClient.post(any, headers: anyNamed('headers'), body: anyNamed('body'))).thenAnswer((_) async =>
         Response(tokensJson, 200, headers: {'content-type': 'application/json'})
      );

      final userController = await UserController.create(keyChain, apiClient);
      final user = await userController.createGuestUser();

      expect(user.id, equals("some-id"));
    });

    test("reuses existing guest user if tokens valid", () async {
      final keyChain = MockKeyChain();
      final mockClient = MockClient();
      final apiClient = ApiClient()..client = mockClient;
      final guestAccess = "old-guest-access";
      final guestRefresh = "old-guest-refresh";
      final userJson = jsonEncode({"id": "old-guest-id", "username": "old-guest"});

      when(keyChain.get("access-token")).thenAnswer((_) async => null);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => null);
      
      when(keyChain.get("guest-access-token")).thenAnswer((_) async => guestAccess);
      when(keyChain.get("guest-refresh-token")).thenAnswer((_) async => guestRefresh);

      // This one calls Get User immediately using guest tokens
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer((_) async {
           return Response(userJson, 200, headers: {'content-type': 'application/json'});
      });

      final userController = await UserController.create(keyChain, apiClient);
      final user = await userController.createGuestUser();

      expect(user.id, equals("old-guest-id"));
      verify(keyChain.set("access-token", guestAccess));
      verify(keyChain.set("refresh-token", guestRefresh));
    });
  });
}
