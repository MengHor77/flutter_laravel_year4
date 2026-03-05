import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/colors.dart';
import '../../../providers/book_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/notification_provider.dart';
import 'package:mobile_year4/screens/frontend/profile/edit_profile.dart';
import '../../../providers/language_provider.dart'; // Import LanguageProvider
import 'package:mobile_year4/screens/frontend/profile/notification_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  // --- មុខងារបង្ហាញផ្ទាំងជ្រើសរើសភាសា (ប្តូរអក្សរតាម Pattern) ---
  void _showLanguagePicker(BuildContext context, bool isDark) {
    final lang = context.read<LanguageProvider>();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.getCardBg(isDark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lang.translate('select_lang'), // ប្រើ Pattern
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(isDark),
                ),
              ),
              const SizedBox(height: 15),
              _buildLanguageOption(
                context,
                lang.translate('khmer'),
                "km",
                isDark,
              ),
              _buildLanguageOption(
                context,
                lang.translate('english'),
                "en",
                isDark,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String label,
    String code,
    bool isDark,
  ) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: AppColors.getTextPrimary(isDark)),
      ),
      leading: const Icon(Icons.language, color: AppColors.accent),
      onTap: () {
        context.read<LanguageProvider>().changeLanguage(code);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final notiProvider = context.watch<NotificationProvider>();
    final lang = context.watch<LanguageProvider>(); // Watch ភាសា

    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDark),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header Section ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
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
                      color: AppColors.getTextPrimary(isDark),
                    ),
                  ),
                  Text(
                    bookProvider.userEmail,
                    style: TextStyle(
                      fontSize: 14,
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
                    lang.translate('acc_settings'), // ប្រើ Pattern
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
                    title: lang.translate('edit_profile'), // ប្រើ Pattern
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
                    title: lang.translate('my_purchases'), // ប្រើ Pattern
                    onTap: () {
                      if (bookProvider.onOrderSuccess != null) {
                        bookProvider.onOrderSuccess!(2);
                      }
                    },
                  ),

                  _buildProfileItem(
                    isDark: isDark,
                    icon: Icons.notifications_none_rounded,
                    title: lang.translate('notifications'), // ប្រើ Pattern
                    customTrailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (notiProvider.unreadCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${notiProvider.unreadCount}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.getBorder(isDark).withOpacity(0.5),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationView(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    lang.translate('preferences'), // ប្រើ Pattern
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
                    title: lang.translate('language'), // ប្រើ Pattern
                    trailingText: lang.isKhmer
                        ? lang.translate('khmer')
                        : lang.translate('english'),
                    onTap: () => _showLanguagePicker(context, isDark),
                  ),

                  _buildProfileItem(
                    isDark: isDark,
                    icon: isDark ? Icons.dark_mode : Icons.light_mode_outlined,
                    title: lang.translate('dark_mode'), // ប្រើ Pattern
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
          color: AppColors.getTextPrimary(isDark), // ប្រើពណ៌ Primary ឱ្យច្បាស់
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: TextStyle(
                color: AppColors.getTextSecondary(
                  isDark,
                ), // ប្រើពណ៌ Secondary សម្រាប់អក្សរតូច
              ),
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
