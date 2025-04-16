import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_app/cubits/user/user_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../commons/constant.dart';
import '../models/quiz.dart';
import '../models/quiz_record.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial());

  Future<void> loadQuiz() async {
    List<Quiz>? questions = await loadQuizData('assets/data/questions.json');
    if (questions != null) {
      List<QuizRecord> records = await loadRecords();
      questions.shuffle();
      questions = questions.take(20).toList();
      questions = questions.map(
        (e) {
          e.answers?.shuffle();
          return e;
        },
      ).toList();
      emit(QuizLoaded(
        questions: questions,
        records: records,
      ));
    } else {
      emit(QuizError());
    }
  }

  void nextQuestion() {
    /// call when choose correct answer or click change question button
    if (state is QuizLoaded) {
      if (state.indexQuestion >= state.questions!.length - 1) {
        saveRecord(index: state.questions!.length);
        emit((state as QuizLoaded).copyWith(message: BlocMessage.completeQuiz));
      } else {
        emit((state as QuizLoaded).copyWith(
            indexQuestion: (state.indexQuestion + 1)
                .clamp(0, state.questions!.length - 1)));
      }
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
        /// get new answer with one of wrong answer hidden
        List<Answer> newAnswers = eliminateOneWrongAnswer(
            state.questions![state.indexQuestion].answers ?? []);
        if (newAnswers.isNotEmpty &&
            newAnswers != state.questions![state.indexQuestion].answers) {
          int newEliminateAnswerCount = state.eliminateAnswerCount - 1;
          emit((state as QuizLoaded)
              .copyWith(eliminateAnswerCount: newEliminateAnswerCount));

          /// update questions
          List<Quiz> questions = List<Quiz>.from(state.questions!);
          questions[state.indexQuestion] = state.questions![state.indexQuestion]
              .copyWith(answers: newAnswers);
          emit((state as QuizLoaded).copyWith(questions: questions));
        }
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

  /// purchase

  void purchaseHeart({required BuildContext context}) {
    if (state is QuizLoaded) {
      int newHeart = state.heart + 2;
      emit((state as QuizLoaded).copyWith(heart: newHeart));
      context.read<UserCubit>().spendCoins(100);
    }
  }

  void purchaseChangeQuizCount({required BuildContext context}) {
    if (state is QuizLoaded) {
      int newCount = state.changeQuizCount + 2;
      emit((state as QuizLoaded).copyWith(changeQuizCount: newCount));
      context.read<UserCubit>().spendCoins(100);
    }
  }

  void purchaseEliminateAnswerCount({required BuildContext context}) {
    if (state is QuizLoaded) {
      int newCount = state.eliminateAnswerCount + 2;
      emit((state as QuizLoaded).copyWith(eliminateAnswerCount: newCount));
      context.read<UserCubit>().spendCoins(100);
    }
  }

  void resetMessage() {
    emit((state as QuizLoaded).copyWith(message: ''));
  }

  /// record
  Future<void> saveRecord({int? index}) async {
    if (state is QuizLoaded) {
      List<QuizRecord> records = (state as QuizLoaded).records ?? [];
      int newRecordCount = index ??
          state.indexQuestion; // ex: indexQuestion = 0 => newRecordCount = 0
      final maxCorrect = records.isEmpty
          ? 0
          : records
              .map((e) => e.correctAnswers)
              .reduce((a, b) => a > b ? a : b);

      if (newRecordCount > maxCorrect) {
        records.add(QuizRecord(
            correctAnswers: newRecordCount, createdAt: DateTime.now()));
        await saveRecordsToPrefs(records);
      }
    }
  }

  Future<void> saveRecordsToPrefs(List<QuizRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(records.map((r) => r.toJson()).toList());
    await prefs.setString('quiz_records', jsonString);
  }

  Future<List<QuizRecord>> loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('quiz_records');
    if (jsonString == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonString);

    List<QuizRecord> records =
        decoded.map((json) => QuizRecord.fromJson(json)).toList();
    records.sort((a, b) => b.correctAnswers.compareTo(a.correctAnswers));
    return records;
  }
}
