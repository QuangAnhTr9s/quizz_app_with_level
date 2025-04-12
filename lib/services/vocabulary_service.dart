import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/vocabulary_model.dart';

class VocabularyService {
  Future<List<Vocabulary>> loadVocabulary(String assetPath) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData.map((item) => Vocabulary.fromJson(item)).toList();
  }
}
