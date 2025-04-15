import 'package:equatable/equatable.dart';

class Quiz extends Equatable {
  final String? question;
  final List<Answer>? answers;

  const Quiz({this.question, this.answers});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      question: json['question'],
      answers: json['answers'] != null
          ? (json['answers'] as List).map((i) => Answer.fromJson(i)).toList()
          : null,
    );
  }

  copyWith({
    String? question,
    List<Answer>? answers,
  }) {
    return Quiz(
      question: question ?? this.question,
      answers: answers ?? this.answers,
    );
  }

  @override
  List<Object?> get props => [question, answers];
}

class Answer extends Equatable {
  final String? answer;
  final bool? isCorrect;
  final bool canShow;

  const Answer({
    this.answer,
    this.isCorrect,
    this.canShow = true,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      answer: json['answer'],
      isCorrect: json['isCorrect'],
    );
  }

  Answer copyWith({
    String? answer,
    bool? isCorrect,
    bool? canShow,
    bool? isSelected,
  }) {
    return Answer(
      answer: answer ?? this.answer,
      isCorrect: isCorrect ?? this.isCorrect,
      canShow: canShow ?? this.canShow,
    );
  }

  @override
  List<Object?> get props => [
        answer,
        isCorrect,
        canShow,
      ];
}
