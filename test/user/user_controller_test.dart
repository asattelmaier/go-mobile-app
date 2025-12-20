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
      // Stub guest tokens to null (default)
      when(keyChain.get("guest-access-token")).thenAnswer((_) async => null);
      when(keyChain.get("guest-refresh-token")).thenAnswer((_) async => null);

      when(httpClient.post("/auth/register/guest"))
          .thenAnswer((_) async => tokensJson);
      final userController = await UserController.create(keyChain, httpClient);
      final user = await userController.createGuestUser();

      expect(user.id, equals("some-id"));
    });

    test("reuses existing guest user if tokens valid", () async {
      final keyChain = MockKeyChain();
      final httpClient = MockHttpClient();
      final guestAccess = "old-guest-access";
      final guestRefresh = "old-guest-refresh";
      final headers = HttpHeadersBuilder.token(guestAccess).build();
      final userJson = {"id": "old-guest-id", "username": "old-guest"};

      // No active session
      when(keyChain.get("access-token")).thenAnswer((_) async => null);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => null);
      
      // Found stored guest tokens
      when(keyChain.get("guest-access-token")).thenAnswer((_) async => guestAccess);
      when(keyChain.get("guest-refresh-token")).thenAnswer((_) async => guestRefresh);

      // Successfully fetches user with stored tokens
      when(httpClient.get("/user", headers)).thenAnswer((_) async => userJson);

      final userController = await UserController.create(keyChain, httpClient);
      final user = await userController.createGuestUser();

      // Should be the old guest
      expect(user.id, equals("old-guest-id"));

      // Should verify that we did NOT call register
      verifyNever(httpClient.post("/auth/register/guest"));
      
      // Should verify that we set the ACTIVE tokens to the guest ones
      verify(keyChain.set("access-token", guestAccess));
      verify(keyChain.set("refresh-token", guestRefresh));
    });

    test("creates new guest user if stored guest tokens are invalid", () async {
      final keyChain = MockKeyChain();
      final httpClient = MockHttpClient();
      final guestAccess = "bad-guest-access";
      final guestRefresh = "bad-guest-refresh";
      
      // New tokens to be created
      final newAccess = "new-access";
      final newRefresh = "new-refresh";
      final tokensJson = {
        "refreshToken": newRefresh,
        "accessToken": newAccess,
      };
      final newUserJson = {"id": "new-id", "username": "new-user"};

      // No active session
      when(keyChain.get("access-token")).thenAnswer((_) async => null);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => null);
      
      // Found stored guest tokens
      when(keyChain.get("guest-access-token")).thenAnswer((_) async => guestAccess);
      when(keyChain.get("guest-refresh-token")).thenAnswer((_) async => guestRefresh);

      // BUT fetching user with them FAILS (e.g. 401/expired)
      // "any" allows us to catch the call despite headers
      when(httpClient.get("/user", any)).thenThrow("Invalid Token"); 
      
      // IMPORTANT: After failing the first check, it will try to register new guest.
      when(httpClient.post("/auth/register/guest")).thenAnswer((_) async => tokensJson);
      
      // And then request the NEW user details
      // We need to match the new headers now.
      final newHeaders = HttpHeadersBuilder.token(newAccess).build();
      when(httpClient.get("/user", newHeaders)).thenAnswer((_) async => newUserJson);

      final userController = await UserController.create(keyChain, httpClient);
      final user = await userController.createGuestUser();

      expect(user.id, equals("new-id"));
      
      // Should have persisted the NEW tokens as guest backup
      verify(keyChain.set("guest-access-token", newAccess));
      verify(keyChain.set("guest-refresh-token", newRefresh));
    });

    test("creates an empty user if registration fails", () async {
      final keyChain = MockKeyChain();
      final httpClient = MockHttpClient();

      when(keyChain.get("access-token")).thenAnswer((_) async => null);
      when(keyChain.get("refresh-token")).thenAnswer((_) async => null);
      when(keyChain.get("guest-access-token")).thenAnswer((_) async => null);
      when(keyChain.get("guest-refresh-token")).thenAnswer((_) async => null);
      
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
      when(keyChain.get("guest-access-token")).thenAnswer((_) async => null);
      when(keyChain.get("guest-refresh-token")).thenAnswer((_) async => null);

      when(httpClient.post("/auth/register/guest")).thenThrow("Some Error");
      final userController = await UserController.create(keyChain, httpClient);
      await userController.createGuestUser();

      verifyNever(keyChain.set("access-token", any));
      verifyNever(keyChain.set("refresh-token", any));
    });
  });
}
