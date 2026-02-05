import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/menu_sidebar.dart';
import '../../providers/book_provider.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<BookProvider>().cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order List"),
        // Move colors here to apply to the whole bar
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppSidebar(currentRoute: 'Order List'),
      body: cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Your order list is empty.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        item.imageUrl,
                        width: 50,
                        height: 70,
                        fit: BoxFit.cover,
                        // FIX: This prevents the "404 Error" text from showing
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            color: Colors.grey[300],
                            child: const Icon(Icons.book, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item.price),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_sweep, color: Colors.red),
                      onPressed: () {
                        context.read<BookProvider>().removeFromCart(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${item.title} removed")),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
