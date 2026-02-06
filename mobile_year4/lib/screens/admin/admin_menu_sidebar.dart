import 'user/user_view.dart';
import 'sale/sale_view.dart';
import 'order/orders_view.dart';
import '../auth/login_view.dart';
import 'category/category_view.dart';
import 'book/manage_books_view.dart';
import 'dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'special/special_offer_view.dart';

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
      DashboardView(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ), // Index 0
      CategoryView(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ), // Index 1
      ManageBooksView(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ), // Index 2
      OrdersView(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ), // Index 3
      SpecialOfferView(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ), // Index 4
      UserView(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ), // Index 5
      SaleView(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ), // Index 6
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        // RoundedRectangleBorder with zero radius keeps it a sharp sidebar
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey[900]),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "ADMIN PANEL",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Expanded allows the menu to take available space and keeps Logout at bottom
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
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                // Navigates to Login and clears the navigation stack
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
      ),
      // Displays the page corresponding to the selected index
      body: pages[_selectedIndex],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    bool isActive = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.blue : Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.blue : Colors.black87,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isActive,
      selectedTileColor: Colors.blue.withOpacity(
        0.1,
      ), 
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }
}
