import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mywallet_mobile/features/authentification/data/model/token_model.dart';
import 'dart:io';

String fixture(String name) =>
    File('test/features/authentification/fixtures/$name').readAsStringSync();
void main() {
  final token = TokenModel(
    tokenRefresh:
        "WQiOiJmOWUzNWM0Ny05NjJlLTQ4Y2QtOWY0MS1mORZrfe5WVTlCBAquc_BaxwNjo",
    tokenAccess: "NDhjZC05ZjQxLWY4MjNmZGY0NjhlZCJ9.8YWHzbzIYkT-",
  );

  group('fromJson', () {
    test('should return a valid model', () async {
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('login_fixture.json'),
      );

      final result = TokenModel.fromJson(jsonMap);

      expect(result, token);
    });
    test('should return a valid JSON map', () async {
      final result = token.toJson();

      final expectedJson = {
        "refresh":
            "WQiOiJmOWUzNWM0Ny05NjJlLTQ4Y2QtOWY0MS1mORZrfe5WVTlCBAquc_BaxwNjo",
      };

      expect(expectedJson, result);
    });
  });
}
