class Vocabulary {
  final String word;
  final String translate;
  final String image;
  final String type;

  Vocabulary({
    required this.word,
    required this.translate,
    required this.image,
    required this.type,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      word: json['word'] ?? '',
      translate: json['translate'] ?? '',
      image: json['image'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'translate': translate,
      'image': image,
      'type': type,
    };
  }
}
