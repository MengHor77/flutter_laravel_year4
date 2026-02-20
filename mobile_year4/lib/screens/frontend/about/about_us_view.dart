import 'package:flutter/material.dart';
import 'package:mobile_year4/colors.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Detect Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      // Ensure the background color matches the theme
      color: AppColors.getBackground(isDark),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // --- App Logo or Illustration ---
            const Icon(
              Icons.menu_book_rounded,
              size: 80,
              color: AppColors.accent,
            ),
            const SizedBox(height: 20),

            // --- Title ---
            Text(
              'About Our Bookstore',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                // USE DYNAMIC PRIMARY TEXT
                color: AppColors.getTextPrimary(isDark),
              ),
            ),
            const SizedBox(height: 15),

            // --- Mission Text ---
            Text(
              'We are a leading bookstore dedicated to providing high-quality educational resources and literature to our community. Our goal is to foster a love for reading and lifelong learning.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                // USE DYNAMIC SECONDARY TEXT
                color: AppColors.getTextSecondary(isDark),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),
            Divider(color: AppColors.getBorder(isDark)),
            const SizedBox(height: 20),

            // --- Features Section ---
            _buildInfoTile(
              context,
              Icons.verified_user_rounded,
              'Quality Selection',
              'Carefully curated books from top publishers.',
              isDark,
            ),
            _buildInfoTile(
              context,
              Icons.delivery_dining_rounded,
              'Fast Delivery',
              'We ensure your books reach you within 24 hours.',
              isDark,
            ),
            _buildInfoTile(
              context,
              Icons.support_agent_rounded,
              '24/7 Support',
              'Our team is always here to help with your orders.',
              isDark,
            ),

            const SizedBox(height: 30),

            // --- Footer Version Info ---
            Text(
              'Version 1.0.0',
              style: TextStyle(
                color: AppColors.getTextSecondary(isDark).withOpacity(0.5),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget updated with isDark parameter
  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool isDark,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        // USE DYNAMIC ACCENT LIGHT BACKGROUND
        backgroundColor: AppColors.accentLight(isDark),
        child: Icon(icon, color: AppColors.accent),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          // USE DYNAMIC PRIMARY TEXT
          color: AppColors.getTextPrimary(isDark),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          // USE DYNAMIC SECONDARY TEXT
          color: AppColors.getTextSecondary(isDark),
        ),
      ),
    );
  }
}
