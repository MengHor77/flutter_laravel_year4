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

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(bookProvider.userName),
            accountEmail: Text(bookProvider.userEmail),
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
                // Shared Menu Items (Indices 0-3)
                _buildMenuItem(context, Icons.home, 'Home', 0),
                _buildMenuItem(context, Icons.menu_book_rounded, 'Books', 1),
                _buildMenuItem(
                  context,
                  Icons.receipt_long_rounded,
                  'Order List',
                  2,
                ),
                _buildMenuItem(
                  context,
                  Icons.workspace_premium,
                  'Best Selling',
                  3,
                ),

                // Drawer-Only Items (Indices 4-5)
                _buildMenuItem(
                  context,
                  Icons.picture_as_pdf_rounded,
                  'Book PDF Free',
                  4,
                ),
                _buildMenuItem(
                  context,
                  Icons.local_offer_rounded,
                  'Special Offers',
                  5,
                ),

                // Profile - Now at Index 6 to match MainWrapper
                _buildMenuItem(context, Icons.person, 'Profile', 6),

                // Remaining Items (Indices 7-8)
                _buildMenuItem(
                  context,
                  Icons.support_agent_rounded,
                  'Contact Us',
                  7,
                ),
                _buildMenuItem(
                  context,
                  Icons.info_outline_rounded,
                  'About Us',
                  8,
                ),

                const Divider(),

                ListTile(
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.danger,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    context.read<BookProvider>().logout();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                      (route) => false,
                    );
                  },
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
  ) {
    bool isActive = currentRoute == title;

    return ListTile(
      selected: isActive,
      selectedTileColor: AppColors.accent.withValues(alpha: 0.1),
      leading: Icon(
        icon,
        color: isActive ? AppColors.accent : AppColors.textPrimary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? AppColors.accent : AppColors.textPrimary,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        if (onIndexChanged != null) {
          onIndexChanged!(index); // Pass the index back to MainWrapper
        }
      },
    );
  }
}
