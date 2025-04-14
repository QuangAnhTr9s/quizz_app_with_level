import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor primaryColor = MaterialColor(
    0xFF0072BB,
    <int, Color>{
      50: Color(0xFFE4F4FF),
      100: Color(0xFFCDE7F8),
      200: Color(0xFFB6DAF1),
      300: Color(0xFFA0CDEB),
      400: Color(0xFF89C0E4),
      500: Color(0xFF5BA6D6),
      600: Color(0xFF2E8CC9),
      700: Color(0xFF0072BB),
      800: Color(0xFF005B96),
      900: Color(0xFF003B61),
    },
  );
  static const Color stateSuccessColor = Color(0xFF33B469);
  static const Color stateWarningColor = Color(0xFFEBBC2E);
  static const Color stateInfoColor = Color(0xFF2F80ED);
  static const Color stateErrorColor = Color(0xFFED3A3A);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const MaterialColor grayColor = MaterialColor(0xFFA6A6B0, <int, Color>{
    5: Color(0xFFFFFFFF),
    10: Color(0xFFF5F5FA),
    20: Color(0xFFEBEBF0),
    30: Color(0xFFDDDDE3),
    40: Color(0xFFC4C4CF),
    50: Color(0xFFA6A6B0),
    60: Color(0xFF808089),
    70: Color(0xFF64646D),
    80: Color(0xFF515158),
    90: Color(0xFF38383D),
    100: Color(0xFF27272A),
    150: Color(0xFF000000),
  });
}
