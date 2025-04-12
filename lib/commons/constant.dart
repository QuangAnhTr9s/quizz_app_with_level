import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constant {
  static List<BoxShadow> boxShadow = [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 4,
      offset: Offset(2, 2), // changes position of shadow
    ),
  ];
}
