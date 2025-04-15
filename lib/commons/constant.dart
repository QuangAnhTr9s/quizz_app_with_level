import 'package:flutter/material.dart';

class Constant {
  static List<BoxShadow> boxShadow = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 4,
      offset: const Offset(2, 2), // changes position of shadow
    ),
  ];
}

/// bloc message
class BlocMessage {
  static String outOfTurns = "Out of turns";
  static String lastTurn = "last turn";
  static String completeQuiz = "complete quiz";
  static String outOfTurnsToChangeQuestion = "out of turns to change question";
  static String outOfTurnsEliminateAnswer = "out of turns eliminate answer";
}
