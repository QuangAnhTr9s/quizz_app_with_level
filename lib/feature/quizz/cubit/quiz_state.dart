part of 'quiz_cubit.dart';

abstract class QuizState extends Equatable {
  final List<Quiz>? questions;
  final int indexQuestion;
  final int heart;
  final int changeQuizCount;
  final int eliminateAnswerCount;

  const QuizState({
    this.questions,
    this.indexQuestion = 0,
    this.heart = 3,
    this.changeQuizCount = 2,
    this.eliminateAnswerCount = 2,
  });
}

class QuizInitial extends QuizState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class QuizLoaded extends QuizState {
  final String? message;
  final List<QuizRecord>? records;

  const QuizLoaded({
    this.message,
    this.records,
    super.questions,
    super.indexQuestion,
    super.heart,
    super.changeQuizCount,
    super.eliminateAnswerCount,
  });

  copyWith({
    String? message,
    List<Quiz>? questions,
    int? indexQuestion,
    int? heart,
    int? changeQuizCount,
    int? eliminateAnswerCount,
    List<QuizRecord>? records,
  }) {
    return QuizLoaded(
      message: message ?? this.message,
      questions: questions ?? this.questions ?? [],
      indexQuestion: indexQuestion ?? this.indexQuestion,
      heart: heart ?? this.heart,
      changeQuizCount: changeQuizCount ?? this.changeQuizCount,
      eliminateAnswerCount: eliminateAnswerCount ?? this.eliminateAnswerCount,
      records: records ?? this.records,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        questions,
        indexQuestion,
        heart,
        message,
        changeQuizCount,
        eliminateAnswerCount,
        records,
      ];
}

class QuizError extends QuizState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
