import 'dashboard_view.dart';
import 'manage_books_view.dart';
import 'package:flutter/material.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardView(),
    const ManageBooksView(),
    const Center(child: Text("Orders Page")),
  ];

  final List<String> _titles = ["Admin Dashboard", "Manage Books", "Orders List"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- THE APPBAR ---
      // Adding the drawer automatically puts the hamburger icon here
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        elevation: 4,
        // Optional: If the icon doesn't show, you can force it like this:
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu), // The Hamburger Icon
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      
      // --- THE DRAWER (Sidebar) ---
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey[900]),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.admin_panel_settings, color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text("ADMIN PANEL", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: _selectedIndex == index ? Colors.blue : Colors.grey),
      title: Text(title, 
        style: TextStyle(
          color: _selectedIndex == index ? Colors.blue : Colors.black,
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() => _selectedIndex = index);
        Navigator.pop(context); // Close the drawer after selection
      },
    );
  }
}