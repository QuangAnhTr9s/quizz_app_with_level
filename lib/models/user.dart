class User {
  final String? userId;
  double coins;
  List<String> unlockedTopics;

  User({this.userId, this.coins = 1000, List<String>? unlockedTopics})
      : unlockedTopics = unlockedTopics ?? [];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'coins': coins,
        'unlockedTopics': unlockedTopics,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        userId: json['userId'],
        coins: (json['coins'] as num).toDouble(),
        unlockedTopics: List<String>.from(json['unlockedTopics'] ?? []),
      );
}
