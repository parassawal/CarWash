import 'package:flutter/material.dart';

class AppColors {
  // Pitch Black Base
  static const Color background = Color(0xFF000000);
  static const Color surface = Color(0xFF0A0A0A);
  static const Color surfaceLight = Color(0xFF141414);
  static const Color card = Color(0xFF111111);
  static const Color cardHover = Color(0xFF1A1A1A);

  // Primary — Clean white accent
  static const Color primary = Color(0xFFFFFFFF);
  static const Color primaryMuted = Color(0xFFB0B0B0);

  // Accent — Subtle warm tone
  static const Color accent = Color(0xFFE23744);
  static const Color accentSoft = Color(0xFF3A1015);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A8A8A);
  static const Color textHint = Color(0xFF4A4A4A);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Rating
  static const Color ratingStar = Color(0xFFFBBF24);
  static const Color ratingGreen = Color(0xFF22C55E);

  // Divider & Border
  static const Color divider = Color(0xFF1F1F1F);
  static const Color border = Color(0xFF262626);

  // Gradients
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFE23744), Color(0xFFFF6B6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient subtleGradient = LinearGradient(
    colors: [Color(0xFF141414), Color(0xFF0A0A0A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
