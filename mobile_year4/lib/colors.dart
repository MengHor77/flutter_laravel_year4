import 'package:flutter/material.dart';

class AppColors {
  // 1. Primary Palette (The Blue/Navy theme you are using)
  static const Color primary = Color(0xFF263238); // blueGrey[900]
  static const Color accent = Colors.blue;        // Standard Blue
  
  // 2. Backgrounds
  static const Color background = Color(0xFFF5F5F5); // grey[100]
  static const Color cardBg = Color.fromARGB(255, 153, 139, 139);
  static const Color lightGray = Color.fromARGB(255, 179, 173, 173);

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
  static Color accentLight = Colors.blue.withValues(alpha:0.1); 
  static Color dangerLight = Colors.red.withValues(alpha:0.1);
  static Color successLight = Colors.green.withValues(alpha:0.1);

  // 7. Extra Text Shades
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textBlack = Color(0xFF000000);
  
}