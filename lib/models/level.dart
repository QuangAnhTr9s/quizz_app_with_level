import 'package:equatable/equatable.dart';

class Level extends Equatable {
  final int? level;
  final String? name;
  final int? hp;
  final int? changeQuestion;
  final int? eliminateAnswer;
  final int? questionCount;
  final String? avatar;
  final bool isDone;

  const Level({
    this.level,
    this.name,
    this.hp,
    this.changeQuestion,
    this.eliminateAnswer,
    this.questionCount,
    this.avatar,
    this.isDone = false,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      level: json['level'] as int?,
      name: json['name'] as String?,
      hp: json['hp'] as int?,
      changeQuestion: json['change_question'] as int?,
      eliminateAnswer: json['eliminate_answer'] as int?,
      questionCount: json['question_count'] as int?,
      avatar: json['avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'name': name,
      'hp': hp,
      'change_question': changeQuestion,
      'eliminate_answer': eliminateAnswer,
      'question_count': questionCount,
      'avatar': avatar,
    };
  }

  Level copyWith({
    int? level,
    String? name,
    int? hp,
    int? changeQuestion,
    int? eliminateAnswer,
    int? questionCount,
    String? avatar,
    bool? isDone,
  }) {
    return Level(
      level: level ?? this.level,
      name: name ?? this.name,
      hp: hp ?? this.hp,
      changeQuestion: changeQuestion ?? this.changeQuestion,
      eliminateAnswer: eliminateAnswer ?? this.eliminateAnswer,
      questionCount: questionCount ?? this.questionCount,
      avatar: avatar ?? this.avatar,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object?> get props => [
        level,
        name,
        hp,
        changeQuestion,
        eliminateAnswer,
        questionCount,
        avatar,
        isDone,
      ];
}
