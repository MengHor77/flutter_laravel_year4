import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/colors.dart';
import '../../../providers/book_provider.dart';
import 'package:mobile_year4/screens/frontend/profile/edit_profile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();

    return SingleChildScrollView(
      child: Column(
        children: [
          // --- Header Section ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.05),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.accent,
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmf4NlFls31qGMTqzjbaNgxmoNwClN9140-A&s',
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  bookProvider.userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  bookProvider.userEmail,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // --- Profile Menu Options ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Account Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),

                _buildProfileItem(
                  icon: Icons.person_outline_rounded,
                  title: "Edit Profile",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileView(),
                      ),
                    );
                  },
                ),
                _buildProfileItem(
                  icon: Icons.shopping_bag_outlined,
                  title: "My Purchases",
                  onTap: () {
                    // Navigate to orders
                  },
                ),
                _buildProfileItem(
                  icon: Icons.notifications_none_rounded,
                  title: "Notifications",
                  onTap: () {},
                ),

                const SizedBox(height: 20),
                const Text(
                  "Preferences",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),

                _buildProfileItem(
                  icon: Icons.language_rounded,
                  title: "Language",
                  trailing: "English",
                  onTap: () {},
                ),
                _buildProfileItem(
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  trailing: "Off",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create consistent ListTiles
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.accent, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }
}
