import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/category_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  static User user = User();

  static const _userKey = 'user_data';
  static const _unlockedKey = 'unlocked_topics';

  /// Gọi ở main() để load dữ liệu
  static Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load user coins
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        user = User.fromJson(jsonDecode(userJson));
      }

      // Load unlocked topics
      final unlockedList = prefs.getStringList(_unlockedKey);
      if (unlockedList != null) {
        user = user.copyWith(
          unlockedTopics: unlockedList,
        );
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  static Future<void> _saveUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(user.toJson()));
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  static Future<void> _saveUnlockedTopics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_unlockedKey, user.unlockedTopics);
    } catch (e) {
      debugPrint('Error saving unlocked topics: $e');
    }
  }

  static void unlock() {
    try {
      // Add unlocking logic here if needed
    } catch (e) {
      debugPrint('Error unlocking topic: $e');
    }
  }

  static Future<void> addCoin({required int coins}) async {
    try {
      int newCoins = user.coins + coins;
      user = user.copyWith(coins: newCoins);
      await _saveUser();
    } catch (e) {
      debugPrint('Error adding coins: $e');
    }
  }

  static Future<void> spendCoin({required int coins}) async {
    try {
      int newCoins = user.coins - coins;
      user = user.copyWith(coins: newCoins);
      await _saveUser();
    } catch (e) {
      debugPrint('Error adding coins: $e');
    }
  }

  static Future<void> purchaseTopic({required Category topic}) async {
    try {
      int newCoins = user.coins - topic.price;
      user = user.copyWith(coins: newCoins);
      if (!user.unlockedTopics.contains(topic.title)) {
        user.unlockedTopics.add(topic.title);
      }
      await _saveUser();
      await _saveUnlockedTopics();
    } catch (e) {
      debugPrint('Error purchasing topic: $e');
    }
  }

  static bool isTopicUnlocked(String title) {
    try {
      return user.unlockedTopics.contains(title);
    } catch (e) {
      debugPrint('Error checking if topic is unlocked: $e');
      return false;
    }
  }
}
