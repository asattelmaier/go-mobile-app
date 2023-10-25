import 'package:flutter_test/flutter_test.dart';
import 'package:go_app/api/http/http_client.dart';
import 'package:go_app/api/local_storage/local_storage.dart';
import 'package:go_app/user/user_controller.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_controller_test.mocks.dart';

@GenerateMocks([LocalStorage, HttpClient])
void main() {
  group("create", () {
    test("creates an empty user if no user id is stored", () async {
      final localStorage = MockLocalStorage();
      final httpClient = MockHttpClient();

      when(localStorage.get("user-id")).thenAnswer((_) async => null);
      final userController =
          await UserController.create(localStorage, httpClient);

      expect(userController.user.isEmpty, isTrue);
    });

    test("creates a user if user id is stored", () async {
      final localStorage = MockLocalStorage();
      final httpClient = MockHttpClient();
      final json = {"id": "some-id", "username": "some-name"};

      when(localStorage.get("user-id")).thenAnswer((_) async => "some-id");
      when(httpClient.get("/user/some-id")).thenAnswer((_) async => json);
      final userController =
          await UserController.create(localStorage, httpClient);

      expect(userController.user.id, equals("some-id"));
    });

    test("creates an empty user if user request fails", () async {
      final localStorage = MockLocalStorage();
      final httpClient = MockHttpClient();

      when(localStorage.get("user-id")).thenAnswer((_) async => "some-id");
      when(httpClient.get("/user/some-id")).thenThrow("Some Error");
      final userController =
          await UserController.create(localStorage, httpClient);

      expect(userController.user.isEmpty, isTrue);
    });

    test("removes user from storage if the user request fails", () async {
      final localStorage = MockLocalStorage();
      final httpClient = MockHttpClient();

      when(localStorage.get("user-id")).thenAnswer((_) async => "some-id");
      when(httpClient.get("/user/some-id")).thenThrow("Some Error");
      await UserController.create(localStorage, httpClient);

      verify(localStorage.remove("user-id"));
    });
  });

  group("createGuestUser", () {
    test("creates a guest user", () async {
      final localStorage = MockLocalStorage();
      final httpClient = MockHttpClient();
      final json = {"id": "some-id", "username": "some-name"};

      when(localStorage.get("user-id")).thenAnswer((_) async => null);
      when(httpClient.post("/user/guest")).thenAnswer((_) async => json);
      final userController =
          await UserController.create(localStorage, httpClient);
      final user = await userController.createGuestUser();

      expect(user.id, equals("some-id"));
    });

    test("creates an empty user if user request fails", () async {
      final localStorage = MockLocalStorage();
      final httpClient = MockHttpClient();

      when(localStorage.get("user-id")).thenAnswer((_) async => null);
      when(httpClient.post("/user/guest")).thenThrow("Some Error");
      final userController =
          await UserController.create(localStorage, httpClient);
      final user = await userController.createGuestUser();

      expect(user.isEmpty, isTrue);
    });

    test("stores no user if user request fails", () async {
      final localStorage = MockLocalStorage();
      final httpClient = MockHttpClient();

      when(localStorage.get("user-id")).thenAnswer((_) async => null);
      when(httpClient.post("/user/guest")).thenThrow("Some Error");
      final userController =
          await UserController.create(localStorage, httpClient);
      await userController.createGuestUser();

      verifyNever(localStorage.set("user-id", any));
    });
  });
}
