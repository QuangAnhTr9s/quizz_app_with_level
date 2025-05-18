import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/category_model.dart';
import '../models/level.dart';

class CategoryService {
  Future<List<Category>> loadCategories(String assetPath) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData.map((item) => Category.fromJson(item)).toList();
  }

  Future<List<Level>> loadLevels(String assetPath) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> jsonData = json.decode(jsonString);

    return jsonData.map((item) => Level.fromJson(item)).toList();
  }
}
