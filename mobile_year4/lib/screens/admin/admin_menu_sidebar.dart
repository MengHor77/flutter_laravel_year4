import 'user/user_view.dart';
import 'sale/sale_view.dart';
import 'book/books_view.dart';
import 'order/orders_view.dart';
import '../auth/login_view.dart';
import 'category/category_view.dart';
import 'dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'special/special_offer_view.dart';
import '../../colors.dart'; // Ensure this points to your colors.dart

class AdminMenuSidebar extends StatefulWidget {
  const AdminMenuSidebar({super.key});

  @override
  State<AdminMenuSidebar> createState() => _AdminMenuSidebarState();
}

class _AdminMenuSidebarState extends State<AdminMenuSidebar> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      CategoryView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      ManageBooksView(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      OrdersView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      SpecialOfferView(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      UserView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      SaleView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
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
            // We use Expanded to ensure the ListView takes the rest of the height
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

                  // MOVED: Logout is now part of the list, right after Sales
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.danger),
                    title: const Text(
                      "Logout",
                      style: TextStyle(
                        color: AppColors.danger,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
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
