import '../../colors.dart';
import 'package:flutter/material.dart';
import '../../screens/auth/login_view.dart';
import '../../screens/admin/user/user_view.dart';
import '../../screens/admin/sale/sale_view.dart';
import '../../screens/admin/book/books_view.dart';
import '../../screens/admin/profile/profile_view.dart';
import '../../screens/admin/order_list/orders_view.dart';
import '../../screens/admin/category/category_view.dart';
import '../../screens/admin/dashboard/dashboard_view.dart';
import '../../screens/admin/free_book/free_book_view.dart';
import '../../screens/admin/special_offer/special_offer_view.dart';
import '../../screens/admin/best_selling_book/best_selling_view.dart';

class AdminMenuSidebar extends StatefulWidget {
  const AdminMenuSidebar({super.key});

  @override
  State<AdminMenuSidebar> createState() => _AdminMenuSidebarState();
}

class _AdminMenuSidebarState extends State<AdminMenuSidebar> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Function to show the Logout Confirmation Pop-up
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            "Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text(
                "CANCEL",
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to login and clear stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              },
              child: const Text(
                "LOGOUT",
                style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      CategoryView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      ManageBooksView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      OrdersView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      SpecialOfferView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      UserView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      SaleView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      BestSellingView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      FreeBookView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      ProfileVeiew(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: AppColors.cardBg,
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      color: AppColors.textOnDark,
                      size: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "ADMIN PANEL",
                      style: TextStyle(
                        color: AppColors.textOnDark,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(Icons.dashboard, "Dashboard", 0),
                  _buildMenuItem(Icons.category, "Category", 1),
                  _buildMenuItem(Icons.book, "Books", 2),
                  _buildMenuItem(Icons.shopping_cart, "Orders", 3),
                  _buildMenuItem(Icons.local_offer, "Special Offer", 4),
                  _buildMenuItem(Icons.people, "Users", 5),
                  _buildMenuItem(Icons.monetization_on, "Sales", 6),
                  _buildMenuItem(Icons.star_rate_rounded, "Best Selling", 7),
                  _buildMenuItem(Icons.picture_as_pdf, "Free Book PDF", 8),
                  _buildMenuItem(Icons.person, "Profile", 9),
                  Divider(
                    thickness: 1,
                    height: 1,
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.danger),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        color: AppColors.danger,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => _showLogoutDialog(context), // Triggers Pop-up
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    bool isActive = _selectedIndex == index;
    return ListTile(
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
      selected: isActive,
      selectedTileColor: AppColors.accent.withValues(alpha: 0.1),
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }
}