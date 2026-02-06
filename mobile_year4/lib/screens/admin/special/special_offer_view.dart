import 'package:flutter/material.dart';

class SpecialOfferView extends StatelessWidget {
  final VoidCallback openDrawer;

  const SpecialOfferView({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Special Offers"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: openDrawer, // Triggers the sidebar drawer
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // Logic to add a new offer
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Active Promotions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Replace with dynamic data from Laravel
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.local_offer,
                        color: Colors.orange,
                      ),
                      title: Text("Seasonal Discount ${index + 1}"),
                      subtitle: const Text("20% Off on all Fiction Books"),
                      trailing: Switch(
                        value: true,
                        onChanged: (val) {
                          // Handle toggle logic here
                        },
                        // Modern switch properties (Flutter 3.31+)
                        activeThumbColor: Colors.green,
                        activeTrackColor: Colors.green.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
