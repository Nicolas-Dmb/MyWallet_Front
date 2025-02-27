import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mywallet_mobile/features/authentification/data/model/user_model.dart';
import 'dart:io';

String fixture(String name) =>
    File('test/features/authentification/fixtures/$name').readAsStringSync();
void main() {
  final tNumberTriviaModel = UserModel(username: "PyTestAll");

  group('fromJson', () {
    test('should return a valid model', () async {
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('registration_fixture.json'),
      );

      final result = UserModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });
  });
}
