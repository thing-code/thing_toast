import 'package:flutter/material.dart';

/// Base Color
const Color successColor = Color(0xFF40DC60);
const Color infoColor = Color(0xFF3382EC);
const Color warningColor = Color(0xFFFEB51A);
const Color errorColor = Color(0xFFFF4D58);
const Color titleColor = Color(0xFF272D2B);
const Color subtitleColor = Color(0xFF818780);

/// Base Gradient
const LinearGradient successGradient = LinearGradient(
  colors: [Color(0xFFEFF8F2), Colors.white],
  stops: [.3, 1],
);
const LinearGradient infoGradient = LinearGradient(
  colors: [Color(0xFFE1EDFA), Colors.white],
  stops: [.3, 1],
);
const LinearGradient warningGradient = LinearGradient(
  colors: [Color(0xFFFEF6E7), Colors.white],
  stops: [.3, 1],
);
const LinearGradient errorGradient = LinearGradient(
  colors: [Color(0xFFFCEDE7), Colors.white],
  stops: [.3, 1],
);
