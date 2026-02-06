import 'dashboard_view.dart';
import 'manage_books_view.dart';
import '../auth/login_view.dart';
import 'package:flutter/material.dart';
// Ensure this import points correctly to your login view

class AdminMenuSidebar extends StatefulWidget {
  const AdminMenuSidebar({super.key});

  @override
  State<AdminMenuSidebar> createState() => _AdminMenuSidebarState();
}

class _AdminMenuSidebarState extends State<AdminMenuSidebar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardView(),
    const ManageBooksView(),
    const Center(child: Text("Orders Page")),
  ];

  final List<String> _titles = [
    "Admin Dashboard",
    "Manage Books",
    "Orders List",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        elevation: 4,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
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
                    const Text(
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
            _buildMenuItem(Icons.shopping_cart, "Orders", 2),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                // Completely clears the navigation stack
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
      body: _pages[_selectedIndex],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(
        icon,
        color: _selectedIndex == index ? Colors.blue : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.blue : Colors.black,
          fontWeight: _selectedIndex == index
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context);
      },
    );
  }
}
