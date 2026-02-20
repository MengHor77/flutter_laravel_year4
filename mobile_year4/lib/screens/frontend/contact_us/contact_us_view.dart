import 'package:flutter/material.dart';
import 'package:mobile_year4/colors.dart'; // Using your AppColors

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      // Ensure the background fills the view with the correct theme color
      color: AppColors.getBackground(isDark),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.contact_support,
            size: 80,
            // Using a standard accent, or you could create getAccent(isDark)
            color: AppColors.accent,
          ),
          const SizedBox(height: 20),
          Text(
            'Contact Support:',
            style: TextStyle(
              fontSize: 18,
              // Dynamic secondary text color
              color: AppColors.getTextSecondary(isDark),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '012 345 678',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              // Dynamic primary text color (instead of hardcoded Colors.black)
              color: AppColors.getTextPrimary(isDark),
            ),
          ),
        ],
      ),
    );
  }
}
