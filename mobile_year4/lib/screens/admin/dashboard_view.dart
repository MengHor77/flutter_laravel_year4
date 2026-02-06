import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  final VoidCallback openDrawer;

  const DashboardView({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // Ensure no extra padding at the top
        automaticallyImplyLeading: false,
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.blueGrey[900], // Your full blue color
        foregroundColor: Colors.white, // White text and icons
        elevation: 0,
        centerTitle: false,
        // Manual leading button to trigger the parent Scaffold's drawer
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: openDrawer,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            _buildStatCard(
              "Total Books",
              "120",
              Icons.library_books,
              Colors.blue,
            ),
            _buildStatCard("Total Users", "45", Icons.people, Colors.green),
            _buildStatCard(
              "Active Orders",
              "12",
              Icons.shopping_cart,
              Colors.orange,
            ),
            _buildStatCard(
              "Revenue",
              "\$450",
              Icons.monetization_on,
              Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}
