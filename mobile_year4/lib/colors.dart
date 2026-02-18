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
      isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

  static Color getCardBg(bool isDark) => 
      isDark ? const Color(0xFF1E1E1E) : const Color.fromRGBO(233, 233, 233, 1);

  static Color getTextPrimary(bool isDark) => 
      isDark ? Colors.white : Colors.black87;

  static Color getTextSecondary(bool isDark) => 
      isDark ? Colors.white70 : Colors.grey;

  static Color getBorder(bool isDark) => 
      isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE);
  
  // 4. Soft Surfaces & Action Backgrounds
  static Color accentLight(bool isDark) => 
      isDark ? Colors.blue.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.1);

 }