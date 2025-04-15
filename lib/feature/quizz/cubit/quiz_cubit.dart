import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../commons/constant.dart';
import '../models/quiz.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial());

  Future<void> loadQuiz() async {
    List<Quiz>? questions = await loadQuizData('assets/data/questions.json');
    if (questions != null) {
      questions.shuffle();
      emit(QuizLoaded(
        questions: questions,
      ));
    } else {
      emit(QuizError());
    }
  }

  void nextQuestion() {
    /// call when choose correct answer or click change question button
    if (state is QuizLoaded) {
      emit((state as QuizLoaded).copyWith(
          indexQuestion:
              (state.indexQuestion + 1).clamp(0, state.questions!.length - 1)));
    }
  }

  void useHeart() {
    if (state is QuizLoaded) {
      if (state.heart > 1) {
        int newHeart = state.heart - 1;
        emit((state as QuizLoaded).copyWith(heart: newHeart));
        if (newHeart == 1) {
          emit((state as QuizLoaded).copyWith(message: BlocMessage.lastTurn));
        }
      } else {
        emit((state as QuizLoaded).copyWith(message: BlocMessage.outOfTurns));
      }
    }
  }

  void eliminateAnswer() {
    if (state is QuizLoaded && state.questions?.isNotEmpty == true) {
      if (state.eliminateAnswerCount > 0) {
        int newEliminateAnswerCount = state.eliminateAnswerCount - 1;
        emit((state as QuizLoaded)
            .copyWith(eliminateAnswerCount: newEliminateAnswerCount));

        /// get new answer with one of wrong answer hidden
        List<Answer> newAnswers = eliminateOneWrongAnswer(
            state.questions![state.indexQuestion].answers ?? []);

        /// update questions
        List<Quiz> questions = List<Quiz>.from(state.questions!);
        questions[state.indexQuestion] =
            state.questions![state.indexQuestion].copyWith(answers: newAnswers);
        emit((state as QuizLoaded).copyWith(questions: questions));
      } else {
        emit((state as QuizLoaded)
            .copyWith(message: BlocMessage.outOfTurnsEliminateAnswer));
      }
    }
  }

  void changeQuestion() {
    if (state is QuizLoaded) {
      if (state.changeQuizCount > 0) {
        int newChangeQuizCount = state.changeQuizCount - 1;
        emit((state as QuizLoaded).copyWith(
          changeQuizCount: newChangeQuizCount,
        ));
        nextQuestion();
      } else {
        emit((state as QuizLoaded)
            .copyWith(message: BlocMessage.outOfTurnsToChangeQuestion));
      }
    }
  }

  Future<List<Quiz>?> loadQuizData(String assetPath) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData.map((item) => Quiz.fromJson(item)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading quiz: $e');
      }
      return null;
    }
  }

  List<Answer> eliminateOneWrongAnswer(List<Answer> answers) {
    final wrongAnswers =
        answers.where((a) => a.isCorrect == false && a.canShow).toList();

    if (wrongAnswers.isEmpty) return answers;

    Answer toRemove = (wrongAnswers..shuffle()).first;

    return answers.map((a) {
      return a.answer == toRemove.answer ? a.copyWith(canShow: false) : a;
    }).toList();
  }
}
