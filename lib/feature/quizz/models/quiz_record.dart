class QuizRecord {
  final int correctAnswers;
  final DateTime createdAt;

  QuizRecord({
    required this.correctAnswers,
    required this.createdAt,
  });

  // Chuyển từ JSON (ví dụ khi lấy từ SharedPreferences hoặc local file)
  factory QuizRecord.fromJson(Map<String, dynamic> json) {
    return QuizRecord(
      correctAnswers: json['correctAnswers'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Chuyển sang JSON (để lưu trữ)
  Map<String, dynamic> toJson() {
    return {
      'correctAnswers': correctAnswers,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
