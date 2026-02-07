import '../../../colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/book_provider.dart';
import '../../../widgets/frontent/menu_sidebar.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    // watch the provider for changes
    final provider = context.watch<BookProvider>();
    final cartItems = provider.cart;

    return Scaffold(
      backgroundColor: AppColors.background,
      // Keep AppBar and Drawer outside the conditional body to prevent "losing" them
      appBar: AppBar(
        title: const Text("Order List"),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnDark,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: const AppSidebar(currentRoute: 'Order List'),
      body: cartItems.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  color: AppColors.cardBg,
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Book Icon/Image
                        Container(
                          width: 50, height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.book, color: AppColors.accent),
                        ),
                        const SizedBox(width: 12),
                        // Text Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text("\$${item.displayPrice}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        // Action Buttons (Match your image)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.red, size: 30),
                              onPressed: () => provider.addToCart(item),
                            ),
                            Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red, size: 30),
                              onPressed: () => provider.decrementQuantity(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => provider.removeFromCart(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty ? null : _buildBottomBar(provider),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("Your order list is empty.", style: TextStyle(color: Colors.grey, fontSize: 16)),
    );
  }

  Widget _buildBottomBar(BookProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Total Amount", style: TextStyle(color: Colors.grey)),
                Text("\$${provider.totalCartPrice.toStringAsFixed(2)}", 
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text("CHECKOUT", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}