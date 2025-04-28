import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mywallet_mobile/core/logger/app_logger.dart';
import 'package:mywallet_mobile/features/trading/domain/entities/question_model.dart';
import 'package:mywallet_mobile/features/trading/domain/trading_quizz_service.dart';

abstract class TradingQuizzState {}

class Initial extends TradingQuizzState {}

class Loading extends TradingQuizzState {}

class OnGoingQuizz extends TradingQuizzState {
  OnGoingQuizz(this.questions, this.totalQuestion, this.currentQuestion);

  final List<QuestionModel> questions;
  final int totalQuestion;
  final int currentQuestion;

  void setAnswer(dynamic answer) {
    questions[currentQuestion] = questions[currentQuestion].setAnswer(answer);
  }

  bool isRequired() {
    return questions[currentQuestion].required;
  }
}

class Success extends TradingQuizzState {}

class Error extends TradingQuizzState {
  Error(this.message, this.lastState);

  final String message;
  final OnGoingQuizz? lastState;
}

class TradingQuizzController extends Cubit<TradingQuizzState> {
  TradingQuizzController(this._tradingQuizzService) : super(Initial());

  final TradingQuizzService _tradingQuizzService;

  get currentQuestion => null;

  Future<void> loadQuizz(bool isBuy, String assetType) async {
    emit(Loading());
    try {
      final questions = await _tradingQuizzService.loadQuizz(isBuy, assetType);
      AppLogger.log(questions.toString());
      emit(OnGoingQuizz(questions, questions.length, 0));
    } catch (e) {
      AppLogger.error(e.toString(), e);
    }
    return;
  }

  Future<void> setAnswerAndContinue(dynamic answer) async {
    if (state is Initial || state is Success || state is Loading) {
      emit(Error('Réponse à la question nécessaire', null));
      return;
    }
    if (state is Error) {
      final errorState = state as Error;
      if (errorState.lastState == null) {
        emit(Error('Réponse à la question nécessaire', null));
        return;
      }
      emit(
        OnGoingQuizz(
          errorState.lastState!.questions,
          errorState.lastState!.totalQuestion,
          errorState.lastState!.currentQuestion,
        ),
      );
    }
    final onGoingState = state as OnGoingQuizz;
    if (answer == null &&
        onGoingState.isRequired() &&
        onGoingState.questions[onGoingState.currentQuestion].answer == null) {
      emit(Error('Réponse à la question nécessaire', onGoingState));
      return;
    }
    onGoingState.setAnswer(answer);
    if (onGoingState.currentQuestion + 1 == onGoingState.totalQuestion) {
      await _submit();
      return;
    }
    _continue(onGoingState);
    return;
  }

  void _continue(OnGoingQuizz onGoingState) {
    emit(
      OnGoingQuizz(
        onGoingState.questions,
        onGoingState.totalQuestion,
        onGoingState.currentQuestion + 1,
      ),
    );
  }

  Future<void> _submit() async {
    emit(Loading());
    //TODO: send data to service
  }

  void goBack(BuildContext context) {
    if (state is Initial || state is Success) {
      _leaveBack(context);
      return;
    }
    if (state is Error) {
      final errorState = state as Error;
      if (errorState.lastState == null) {
        _leaveBack(context);
        return;
      }
      emit(
        OnGoingQuizz(
          errorState.lastState!.questions,
          errorState.lastState!.totalQuestion,
          errorState.lastState!.currentQuestion - 1,
        ),
      );
      return;
    }
    if (state is Loading) {
      return;
    }
    final onGoingState = state as OnGoingQuizz;
    if (onGoingState.currentQuestion == 0) {
      _leaveBack(context);
      return;
    }
    emit(
      OnGoingQuizz(
        onGoingState.questions,
        onGoingState.totalQuestion,
        onGoingState.currentQuestion - 1,
      ),
    );
  }

  void _leaveBack(BuildContext context) {
    context.pop();
    emit(Initial());
    return;
  }
}
