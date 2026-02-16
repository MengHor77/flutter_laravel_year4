import 'package:flutter/material.dart';
import 'package:mobile_year4/colors.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    // ❌ Removed Scaffold, AppBar, and Drawer here because they are provided by MainWrapper
    return SingleChildScrollView(
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
          const Text(
            'About Our Bookstore',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          
          // --- Mission Text ---
          const Text(
            'We are a leading bookstore dedicated to providing high-quality educational resources and literature to our community. Our goal is to foster a love for reading and lifelong learning.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 20),

          // --- Features Section ---
          _buildInfoTile(
            Icons.verified_user_rounded,
            'Quality Selection',
            'Carefully curated books from top publishers.',
          ),
          _buildInfoTile(
            Icons.delivery_dining_rounded,
            'Fast Delivery',
            'We ensure your books reach you within 24 hours.',
          ),
          _buildInfoTile(
            Icons.support_agent_rounded,
            '24/7 Support',
            'Our team is always here to help with your orders.',
          ),

          const SizedBox(height: 30),
          
          // --- Footer Version Info ---
          const Text(
            'Version 1.0.0',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Helper widget to display features/info
  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        backgroundColor: AppColors.accent.withOpacity(0.1),
        child: Icon(icon, color: AppColors.accent),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
    );
  }
}