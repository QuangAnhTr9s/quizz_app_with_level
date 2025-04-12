import 'dart:math';

import 'package:flash_card_app/purchase/models/coin_package.dart';
import 'package:flash_card_app/purchase/models/sub_package.dart';
import 'package:flutter/material.dart';

import '../purchase/config_key.dart';

class AppInfoConstants {
  static String get appId => '0';
  static String? _userId;
  static String get userId => _userId ?? generateUserId();
  static set userId(String value) {
    _userId = value;
  }

  static List<Color> noteColors = [
    const Color(0xFFFFFFFF), // Trắng
    const Color(0xFFFFF8E1), // Vàng kem nhạt
    const Color(
        0xFFB3E5FC), // Xanh dương pastel (nhạt để không chìm với text blue)
    const Color(0xFFFFCDD2), // Hồng pastel nhạt (hợp với text red)
    const Color(0xFFDCEDC8), // Xanh bạc hà nhạt
    const Color(0xFFFFE0B2), // Cam nhạt (không bị trùng với orangeAccent)
    const Color(0xFFF0F4C3), // Xanh lá pastel nhẹ
    const Color(0xFFD1C4E9), // Tím pastel nhạt
    const Color(0xFFCFD8DC), // Xám xanh nhạt
    const Color(0xFFFFEBEE), // Hồng nhạt gần trắng
  ];

  static final List<SubPackage> listSubPackages = [
    SubPackage(
      months: 0.25,
      price: 0.99,
      keyStoreAndroid: ConfigKey.keySub1Android,
      keyStoreIOS: ConfigKey.keySub1Ios,
      name: '1 Week Plan',
    ),
    SubPackage(
      months: 1,
      price: 4.99,
      keyStoreAndroid: ConfigKey.keySub2Android,
      keyStoreIOS: ConfigKey.keySub2Ios,
      name: '1 Month Plan',
    ),
    SubPackage(
      months: 2,
      price: 9.99,
      keyStoreAndroid: ConfigKey.keySub3Android,
      keyStoreIOS: ConfigKey.keySub3Ios,
      name: '2 Month Plan',
    ),
    SubPackage(
      months: 3,
      price: 19.9,
      keyStoreAndroid: ConfigKey.keySub4Android,
      keyStoreIOS: ConfigKey.keySub4Ios,
      name: '3 Month Plan',
    ),
    SubPackage(
      months: 4,
      price: 49.9,
      keyStoreAndroid: ConfigKey.keySub5Android,
      keyStoreIOS: ConfigKey.keySub5Ios,
      name: '4 Month Plan',
    ),
    SubPackage(
      months: 6,
      price: 99.9,
      keyStoreAndroid: ConfigKey.keySub6Android,
      keyStoreIOS: ConfigKey.keySub6Ios,
      name: '6 Month Plan',
    ),
  ];
  static final List<CoinPackage> coinsPackages = [
    CoinPackage(
        imageAsset: 'assets/coin.png',
        coinAmount: 100,
        price: '\$0.99',
        keyStore: ConfigKey.keyCoin1),
    CoinPackage(
        imageAsset: 'assets/coin_2.png',
        coinAmount: 250,
        price: '\$1.99',
        keyStore: ConfigKey.keyCoin2),
    CoinPackage(
        imageAsset: 'assets/coin_2.png',
        coinAmount: 500,
        price: '\$3.49',
        keyStore: ConfigKey.keyCoin3),
    CoinPackage(
        imageAsset: 'assets/coin_2.png',
        coinAmount: 1000,
        price: '\$5.99',
        keyStore: ConfigKey.keyCoin4),
    CoinPackage(
        imageAsset: 'assets/coin_2.png',
        coinAmount: 2000,
        price: '\$9.99',
        keyStore: ConfigKey.keyCoin5),
    CoinPackage(
        imageAsset: 'assets/coin_2.png',
        coinAmount: 5000,
        price: '\$19.99',
        keyStore: ConfigKey.keyCoin6),
  ];

  static String generateUserId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999);
    return 'user_$timestamp$random';
  }
}
