import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mywallet_mobile/features/trading/domain/entities/question_model.dart';

class TradingQuizzService {
  Future<List<QuestionModel>> loadQuizz(bool isBuy, String assetType) async {
    final String jsonString = await _loadJsonFile(isBuy);
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    final List<dynamic> jsonQuestions = jsonMap[assetType];
    final questions =
        jsonQuestions
            .map((jsonQuestion) => QuestionModel.fromJson(jsonQuestion))
            .toList();
    return questions;
  }

  Future<String> _loadJsonFile(bool isBuy) async {
    final String jsonString;
    if (isBuy) {
      jsonString = await rootBundle.loadString(
        'lib/features/trading/domain/json_questions/buy_quizz.json',
      );
    } else {
      jsonString = await rootBundle.loadString(
        'lib/features/trading/domain/json_questions/sell_quizz.json',
      );
    }
    return jsonString;
  }

  static void inject() {}
}
