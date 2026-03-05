import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/colors.dart';
import '../../../providers/book_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/notification_provider.dart';
import 'package:mobile_year4/screens/frontend/profile/edit_profile.dart';
import 'package:mobile_year4/screens/frontend/profile/notification_view.dart';
import 'package:mobile_year4/screens/frontend/profile/notification_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    // Watch theme changes
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;
    final notiProvider = context.watch<NotificationProvider>();

    return Scaffold(
      // Use adaptive background color
      backgroundColor: AppColors.getBackground(isDark),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header Section ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                // Adaptive header color
                color: AppColors.accentLight(isDark),
                border: Border(
                  bottom: BorderSide(color: AppColors.getBorder(isDark)),
                ),
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
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      // Adaptive text color
                      color: AppColors.getTextPrimary(isDark),
                    ),
                  ),
                  Text(
                    bookProvider.userEmail,
                    style: TextStyle(
                      fontSize: 14,
                      // Adaptive secondary text color
                      color: AppColors.getTextSecondary(isDark),
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
                  Text(
                    "Account Settings",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.getTextSecondary(isDark),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildProfileItem(
                    isDark: isDark,
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
                    isDark: isDark,
                    icon: Icons.shopping_bag_outlined,
                    title: "My Purchases",
                    onTap: () {
                      if (bookProvider.onOrderSuccess != null) {
                        bookProvider.onOrderSuccess!(2);
                      }
                    },
                  ),

            _buildProfileItem(
  isDark: isDark,
  icon: Icons.notifications_none_rounded,
  title: "Notifications",
  customTrailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (notiProvider.unreadCount > 0) // បង្ហាញ Badge តែពេលមានសារមិនទាន់អាន
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "${notiProvider.unreadCount}",
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      const SizedBox(width: 8),
      Icon(
        Icons.chevron_right_rounded,
        color: AppColors.getBorder(isDark).withValues(alpha:0.5),
      ),
    ],
  ),
  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationView())),
),

                  const SizedBox(height: 20),
                  Text(
                    "Preferences",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.getTextSecondary(isDark),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildProfileItem(
                    isDark: isDark,
                    icon: Icons.language_rounded,
                    title: "Language",
                    trailingText: "English",
                    onTap: () {},
                  ),

                  // --- Dark Mode Toggle Row ---
                  _buildProfileItem(
                    isDark: isDark,
                    icon: isDark ? Icons.dark_mode : Icons.light_mode_outlined,
                    title: "Dark Mode",
                    // Pass a Switch as the custom trailing widget
                    customTrailing: Switch(
                      value: isDark,
                      activeColor: AppColors.accent,
                      onChanged: (value) {
                        themeProvider.toggleTheme();
                      },
                    ),
                    onTap: () {
                      themeProvider.toggleTheme();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create consistent ListTiles with adaptive colors
  Widget _buildProfileItem({
    required bool isDark,
    required IconData icon,
    required String title,
    String? trailingText,
    Widget? customTrailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.accentLight(isDark),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.accent, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.getTextPrimary(isDark),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(color: AppColors.getTextSecondary(isDark)),
            ),
          customTrailing ??
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.getBorder(isDark).withOpacity(0.5),
              ),
        ],
      ),
      onTap: onTap,
    );
  }
}
