import 'user_view.dart';
import 'sale_view.dart';
import 'orders_view.dart';
import 'category_view.dart';
import 'dashboard_view.dart';
import 'manage_books_view.dart';
import 'special_offer_view.dart';
import '../auth/login_view.dart';
import 'package:flutter/material.dart';

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
    // Pass the openDrawer function so child AppBars can open this drawer
    final List<Widget> pages = [
      DashboardView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      ManageBooksView(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      CategoryView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      OrdersView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      SpecialOfferView(
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      UserView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
      SaleView(openDrawer: () => _scaffoldKey.currentState?.openDrawer()),
    ];

    return Scaffold(
      key: _scaffoldKey,
      // We don't put an AppBar here so the child pages can have their own full-color ones
      drawer: Drawer(
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildMenuItem(Icons.dashboard, "Dashboard", 0),
            _buildMenuItem(Icons.book, "Books", 1),
            _buildMenuItem(Icons.category, "Category", 2),
            _buildMenuItem(Icons.shopping_cart, "Orders", 3),
            _buildMenuItem(Icons.local_offer, "Special Offer", 4),
            _buildMenuItem(Icons.people, "User", 5),
            _buildMenuItem(Icons.monetization_on, "Sale", 6),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      body:
          pages[_selectedIndex], // Removed SafeArea here to let AppBar touch the top
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    bool isActive = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(color: isActive ? Colors.blue : Colors.black),
      ),
      selected: isActive,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }
}
