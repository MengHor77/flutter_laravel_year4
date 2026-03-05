import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/colors.dart';
import '../../../providers/book_provider.dart';
import 'package:mobile_year4/screens/auth/login_view.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;
  final Function(int)? onIndexChanged;

  const AppSidebar({
    super.key,
    this.currentRoute = 'Home',
    this.onIndexChanged,
  });

  void _showLogoutDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //  Adaptive background for Dialog
          backgroundColor: AppColors.getCardBg(isDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Logout",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(isDark),
            ),
          ),
          content: Text(
            "Are you sure you want to sign out?",
            style: TextStyle(color: AppColors.getTextSecondary(isDark)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                context.read<BookProvider>().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              },
              child: Text(
                "LOGOUT",
                style: TextStyle(color: AppColors.getDanger(isDark)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    // Detect Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      //  Dynamic background for the Drawer surface
      backgroundColor: AppColors.getBackground(isDark),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              bookProvider.userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(bookProvider.userEmail),
            // Header usually keeps accent color, but you can dim it if needed
            decoration: const BoxDecoration(color: AppColors.accent),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmf4NlFls31qGMTqzjbaNgxmoNwClN9140-A&s',
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(context, Icons.home, 'Home', 0, isDark),
                _buildMenuItem(
                  context,
                  Icons.menu_book_rounded,
                  'Books',
                  1,
                  isDark,
                ),
                _buildMenuItem(
                  context,
                  Icons.receipt_long_rounded,
                  'Order List',
                  2,
                  isDark,
                ),
                _buildMenuItem(
                  context,
                  Icons.workspace_premium,
                  'Best Selling',
                  3,
                  isDark,
                ),
                _buildMenuItem(
                  context,
                  Icons.picture_as_pdf_rounded,
                  'Book PDF Free',
                  4,
                  isDark,
                ),
                _buildMenuItem(
                  context,
                  Icons.local_offer_rounded,
                  'Special Offers',
                  5,
                  isDark,
                ),
                _buildMenuItem(context, Icons.person, 'Profile', 6, isDark),
                _buildMenuItem(
                  context,
                  Icons.support_agent_rounded,
                  'Contact Us',
                  7,
                  isDark,
                ),
                _buildMenuItem(
                  context,
                  Icons.info_outline_rounded,
                  'About Us',
                  8,
                  isDark,
                ),
                Divider(color: AppColors.getBorder(isDark)),
                ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    color: AppColors.getDanger(isDark),
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: AppColors.getDanger(isDark),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () => _showLogoutDialog(context, isDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    int index,
    bool isDark,
  ) {
    bool isActive = currentRoute == title;

    // Define adaptive colors for items
    Color activeColor = AppColors.accent;
    Color inactiveColor = AppColors.getTextPrimary(isDark);

    return ListTile(
      selected: isActive,
      // Soft highlight color for active item
      selectedTileColor: activeColor.withValues(alpha:isDark ? 0.15 : 0.2),
      leading: Icon(icon, color: isActive ? activeColor : inactiveColor),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? activeColor : inactiveColor,  
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (onIndexChanged != null) onIndexChanged!(index);
      },
    );
  }
}


  /* 
  condition ? value_if_true : value_if_false;

  condition ជាលក្ខខណ្ឌដែលផ្ដល់លទ្ធផលជា true (ពិត) ឬ false (មិនពិត)។

  ? ជាសញ្ញាសួរដើម្បីសួរថា តើលក្ខខណ្ឌខាងលើពិតមែនទេ?

  value_if_true  ជាតម្លៃដែលនឹងត្រូវយកទៅប្រើ ប្រសិនបើលក្ខខណ្ឌពិត។

  : សញ្ញាចុចពីរ តំណាងឱ្យពាក្យថា "ក្រៅពីនេះ" (Else)។

  value_if_false  ជាតម្លៃដែលនឹងត្រូវយកទៅប្រើ ប្រសិនបើលក្ខខណ្ឌមិនពិត។
  */