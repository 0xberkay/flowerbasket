import 'dart:math';

import 'package:flutter/material.dart';

class MyColors {
  static const MaterialColor primary = Colors.deepPurple;
  static const Color secondary = Color.fromARGB(255, 127, 97, 179);
  static const Color tertiary = Color.fromARGB(255, 202, 190, 222);
  static const Color quaternary = Color.fromARGB(255, 237, 234, 242);
  static const Color bold = Color.fromARGB(255, 34, 17, 60);
  static const Color back = Color.fromARGB(255, 244, 241, 252);
  static const Color red = Color.fromARGB(255, 202, 97, 95);
}

Color randomColor() {
  return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}
