import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/api/http/http_client.dart';
import 'package:go_app/api/http_headers/http_headers_builder.dart';
import 'package:go_app/api/key_chain/key_chain.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_controller_test.mocks.dart';

@GenerateMocks([KeyChain, HttpClient])
void main() {
  group("create", () {
    test("creates an empty user if no tokens are stored", () async {
      final keyChain = MockKeyChain();
      final httpClient = MockHttpClient();

      when(keyChain.get("access-token")).thenAnswer((_) async => null);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => null);
      final userController = await UserController.create(keyChain, httpClient);

      expect(userController.user.isEmpty, isTrue);
    });

    test("creates a user if tokens are stored", () async {
      final keyChain = MockKeyChain();
      final httpClient = MockHttpClient();
      final accessToken = "some-token";
      final refreshToken = "some-other-token";
      final headers = HttpHeadersBuilder.token(accessToken).build();
      final userJson = {"id": "some-id", "username": "some-name"};

      when(keyChain.get("access-token")).thenAnswer((_) async => accessToken);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => refreshToken);
      when(httpClient.get("/user", headers)).thenAnswer((_) async => userJson);
      final userController = await UserController.create(keyChain, httpClient);

      expect(userController.user.id, equals("some-id"));
    });

    test("creates an empty user if user request fails", () async {
      final keyChain = MockKeyChain();
      final httpClient = MockHttpClient();
      final accessToken = "some-token";
      final refreshToken = "some-other-token";

      when(keyChain.get("access-token")).thenAnswer((_) async => accessToken);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => refreshToken);
      when(httpClient.get("/user", any)).thenThrow("Some Error");
      final userController = await UserController.create(keyChain, httpClient);

      expect(userController.user.isEmpty, isTrue);
    });

    test("removes user from storage if the user request fails", () async {
      final keyChain = MockKeyChain();
      final httpClient = MockHttpClient();
      final accessToken = "some-token";
      final refreshToken = "some-other-token";

      when(keyChain.get("access-token")).thenAnswer((_) async => accessToken);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => refreshToken);
      when(httpClient.get("/user", any)).thenThrow("Some Error");
      await UserController.create(keyChain, httpClient);

      verify(keyChain.remove("access-token"));
      verify(keyChain.remove("refresh-token"));
    });
  });

  group("createGuestUser", () {
    test("creates a guest user", () async {
      final keyChain = MockKeyChain();
      final httpClient = MockHttpClient();
      final accessToken = "some-token";
      final headers = HttpHeadersBuilder.token(accessToken).build();
      final tokensJson = {
        "refreshToken": "some-other-token",
        "accessToken": accessToken,
      };
      final userJson = {"id": "some-id", "username": "some-name"};

      when(httpClient.get("/user", headers)).thenAnswer((_) async => userJson);
      when(keyChain.get("access-token")).thenAnswer((_) async => null);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => null);
      when(httpClient.post("/auth/register/guest"))
          .thenAnswer((_) async => tokensJson);
      final userController = await UserController.create(keyChain, httpClient);
      final user = await userController.createGuestUser();

      expect(user.id, equals("some-id"));
    });

    test("creates an empty user if registration fails", () async {
      final keyChain = MockKeyChain();
      final httpClient = MockHttpClient();

      when(keyChain.get("access-token")).thenAnswer((_) async => null);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => null);
      when(httpClient.post("/auth/register/guest")).thenThrow("Some Error");
      final userController = await UserController.create(keyChain, httpClient);
      final user = await userController.createGuestUser();

      expect(user.isEmpty, isTrue);
    });

    test("stores no token if registration fails", () async {
      final keyChain = MockKeyChain();
      final httpClient = MockHttpClient();

      when(keyChain.get("access-token")).thenAnswer((_) async => null);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => null);
      when(httpClient.post("/auth/register/guest")).thenThrow("Some Error");
      final userController = await UserController.create(keyChain, httpClient);
      await userController.createGuestUser();

      verifyNever(keyChain.set("access-token", any));
      verifyNever(keyChain.set("refresh-token", any));
    });
  });
}
