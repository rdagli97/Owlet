import 'package:flutter/material.dart';

/// Owlet's entire color palette.
class AppColors {
  AppColors._();

  // Main background colors (night owl — dark)
  static const Color background = Color(0xFF15181C);      // darkest ground
  static const Color surface = Color(0xFF1E2329);         // cards, surfaces
  static const Color surfaceLight = Color(0xFF2A313A);    // slightly elevated

  // Accent colors (owl eyes — amber/gold)
  static const Color primary = Color(0xFFE8A94B);         // main amber
  static const Color primaryDark = Color(0xFFC98A2E);     // dark amber

  // Text colors
  static const Color textPrimary = Color(0xFFF5F5F5);     // main white text
  static const Color textSecondary = Color(0xFF9BA3AD);   // pale gray text
  static const Color textMuted = Color(0xFF5C6570);       // very pale

  // Situation colors
  static const Color like = Color(0xFFE0245E);            // like (red-pink)
  static const Color retweet = Color(0xFF17BF63);         // retweet (green)
  static const Color error = Color(0xFFE0245E);           // error
  static const Color divider = Color(0xFF2A313A);         // parentheses
}