import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/screens/auth/login_view.dart';
import 'package:mobile_year4/screens/frontend/book/book_view.dart';
import 'package:mobile_year4/screens/frontend/home/home_view.dart';
import 'package:mobile_year4/screens/frontend/about/about_us_view.dart';
import 'package:mobile_year4/colors.dart'; // Ensure correct path to AppColors
import 'package:mobile_year4/screens/frontend/order_list/order_list_view.dart';
import 'package:mobile_year4/screens/frontend/contact_us/contact_us_view.dart';
import 'package:mobile_year4/screens/frontend/book_pdf_free/book_pdf_view.dart';
import '../../../providers/book_provider.dart'; // Import provider to get user data
import 'package:mobile_year4/screens/frontend/special_offer/special_offers_view.dart';
import 'package:mobile_year4/screens/frontend/best_selling_view/best_selling_view.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;
  const AppSidebar({super.key, this.currentRoute = 'Home'});

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final String userName = bookProvider.userName;
    final String userEmail = bookProvider.userEmail;

    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(bookProvider.userName),
            accountEmail: Text(bookProvider.userEmail),
            // USE APPCOLOR: Replaced hardcoded Color.fromARGB
            decoration: const BoxDecoration(color: AppColors.accent),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: AppColors.accent,
              backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmf4NlFls31qGMTqzjbaNgxmoNwClN9140-A&s',
              ),
            ),
          ),

          // Menu Items
          _buildMenuItem(context, Icons.home, 'Home', const HomeView()),
          _buildMenuItem(
            context,
            Icons.menu_book_rounded,
            'Books',
            const BookView(),
          ),
          _buildMenuItem(
            context,
            Icons.receipt_long_rounded,
            'Order List',
            const OrderListView(),
          ),
          _buildMenuItem(
            context,
            Icons.workspace_premium,
            'Best Selling',
            const BestSellingView(),
          ),
          _buildMenuItem(
            context,
            Icons.picture_as_pdf_rounded,
            'Book PDF Free',
            const BookPdfView(),
          ),
          _buildMenuItem(
            context,
            Icons.local_offer_rounded,
            'Special Offers',
            const SpecialOffersView(),
          ),
          _buildMenuItem(
            context,
            Icons.support_agent_rounded,
            'Contact Us',
            const ContactUsView(),
          ),
          _buildMenuItem(
            context,
            Icons.info_outline_rounded,
            'About Us',
            const AboutUsView(),
          ),

          // Logout Item
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.danger),
            title: const Text(
              'Logout',
              style: TextStyle(
                color: AppColors.danger,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              // Clear snackbars on logout to be safe
            context.read<BookProvider>().logout();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget destination,
  ) {
    bool isActive = currentRoute == title;
    return ListTile(
      selected: isActive,
      // USE APPCOLOR: Replaced Colors.blue
      selectedTileColor: AppColors.accent.withValues(alpha: 0.1),
      leading: Icon(
        icon,
        color: isActive ? AppColors.accent : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? AppColors.accent : AppColors.textPrimary,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (!isActive) {
          // Clear any active snackbars when switching pages via sidebar
          ScaffoldMessenger.of(context).removeCurrentSnackBar();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
    );
  }
}
