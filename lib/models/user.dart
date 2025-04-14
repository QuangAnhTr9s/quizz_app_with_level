import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? userId;
  final int coins;
  final List<String> unlockedTopics;

  User({this.userId, this.coins = 1000, List<String>? unlockedTopics})
      : unlockedTopics = unlockedTopics ?? [];

  copyWith({String? userId, int? coins, List<String>? unlockedTopics}) {
    return User(
      userId: userId ?? this.userId,
      coins: coins ?? this.coins,
      unlockedTopics: unlockedTopics ?? this.unlockedTopics,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'coins': coins,
        'unlockedTopics': unlockedTopics,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        userId: json['userId'],
        coins: (json['coins'] as num).toInt(),
        unlockedTopics: List<String>.from(json['unlockedTopics'] ?? []),
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        userId,
        coins,
        unlockedTopics,
      ];
}
