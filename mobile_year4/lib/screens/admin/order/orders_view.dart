import 'package:flutter/material.dart';

class OrdersView extends StatelessWidget {
  final VoidCallback openDrawer;
  const OrdersView({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Orders"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: openDrawer,
        ),
      ),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.shopping_bag)),
            title: Text("Order #ORD-10$index"),
            subtitle: const Text("Status: Pending"),
            trailing: const Text(
              "\$25.00",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}
