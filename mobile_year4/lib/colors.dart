import 'package:flutter/material.dart';

class AppColors {
  // 1. Primary Palette (The Blue/Navy theme you are using)
  static const Color primary = Color(0xFF263238); // blueGrey[900]
  static const Color accent = Colors.blue;        // Standard Blue
  static const Color accentDark = Color(0xFF1976D2); // Darker blue for contrast
  // 2. Backgrounds
  static const Color background = Color(0xFFF5F5F5); // grey[100]
  static const Color cardBg = Color.fromRGBO(233, 233, 233, 1);
  static const Color lightGray = Color.fromARGB(211, 234, 224, 224);

  // 3. Status/Action Colors
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color danger = Colors.red;

  // 4. Text Colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
  static const Color textOnDark = Colors.white;
  // 5. Soft Surfaces & Borders
  static const Color border = Color(0xFFEEEEEE);      // For thin lines between items
  static const Color shadow = Color(0x0D000000);      // Very light shadow (5% opacity)
  
  // 6. Light Action Backgrounds (Great for icon circles)
  // static Color accentLight = Colors.blue.withValues(alpha:0.1); 
  static Color dangerLight = Colors.red.withValues(alpha:0.1);
  static Color successLight = Colors.green.withValues(alpha:0.1);

  // 7. Extra Text Shades
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textBlack = Color(0xFF000000);


static Color getBackground(bool isDark) => 
      isDark ? const Color(0xFF0F171E) : const Color(0xFFF8F9FA);

  // Cards should be slightly lighter than the background to "pop"
  static Color getCardBg(bool isDark) => 
      isDark ? const Color(0xFF1C252E) : Colors.white;

  // Avoid pure white; use an off-white for better readability
  static Color getTextPrimary(bool isDark) => 
      isDark ? const Color(0xFFE1E1E1) : const Color(0xFF2D3436);

  static Color getTextSecondary(bool isDark) => 
      isDark ? Colors.white60 : Colors.grey.shade600;

  static Color getBorder(bool isDark) => 
      isDark ? const Color(0xFF2C3E50).withOpacity(0.3) : const Color(0xFFEEEEEE);
  
  static Color accentLight(bool isDark) => 
      isDark ? Colors.blue.withOpacity(0.15) : Colors.blue.withOpacity(0.08);

  // Status colors with softer tones for dark mode
  static Color getSuccess(bool isDark) => 
      isDark ? const Color(0xFF2ECC71) : Colors.green;

  static Color getDanger(bool isDark) => 
      isDark ? const Color(0xFFE74C3C) : Colors.red;
 }