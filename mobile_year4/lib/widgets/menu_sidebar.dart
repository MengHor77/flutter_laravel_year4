import 'package:flutter/material.dart';
import 'package:mobile_year4/screens/home/home_view.dart';
import 'package:mobile_year4/screens/book/book_view.dart';
import 'package:mobile_year4/screens/login/login_view.dart';
import 'package:mobile_year4/screens/about/about_us_view.dart';
import 'package:mobile_year4/screens/order_list/order_list_view.dart';
import 'package:mobile_year4/screens/contact_us/contact_us_view.dart';
import 'package:mobile_year4/screens/book_pdf_free/book_pdf_view.dart';
import 'package:mobile_year4/screens/special_offer/special_offers_view.dart';
import 'package:mobile_year4/screens/best_selling_view/best_selling_view.dart';

class AppSidebar extends StatelessWidget {
  final String currentRoute;
  const AppSidebar({super.key, this.currentRoute = 'Home'});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: ListView(
        // Changed from Column to ListView for the whole drawer
        padding: EdgeInsets.zero,
        children: [
           const UserAccountsDrawerHeader(
            accountName:  Text('Nita Vann'),
            accountEmail:  Text('account@example.com'),
            // ADD THIS LINE TO CHANGE COLOR:
            decoration:  BoxDecoration(color: Color.fromARGB(255, 45, 135, 208)),
            currentAccountPicture:  CircleAvatar(
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

          // Logout Item (Now directly under the menu)
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 20), // Padding at the bottom
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
      selectedTileColor: Colors.blue.withValues(alpha: 0.1),
      leading: Icon(icon, color: isActive ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(color: isActive ? Colors.blue : Colors.black),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (!isActive) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        }
      },
    );
  }
}
