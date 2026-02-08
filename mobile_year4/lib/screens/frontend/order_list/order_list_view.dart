import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../checkout_view/checkout_view.dart';
import '../../../providers/book_provider.dart';
import '../../../widgets/frontent/menu_sidebar.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  // Helper to handle the URL correctly
  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return 'https://via.placeholder.com/150';

    if (path.startsWith('http')) {
      return path;
    }

    String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return "${ApiConfig.storage}$cleanPath";
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes
    final provider = context.watch<BookProvider>();
    final cartItems = provider.cart;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                        // --- IMAGE SECTION ---
                        Container(
                          width: 50,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _getImageUrl(item.image),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.broken_image,
                                    color: AppColors.accent,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // --- TEXT INFO ---
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "\$${item.displayPrice}",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // --- ACTION BUTTONS ---
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.blue,
                                size: 28,
                              ),
                              onPressed: () => provider.addToCart(item),
                            ),
                            Text(
                              "${item.quantity}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                                size: 28,
                              ),
                              onPressed: () =>
                                  provider.decrementQuantity(index),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                              ),
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
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : _buildBottomBar(context, provider),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "Your order list is empty.",
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, BookProvider provider) {
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
                const Text(
                  "Total Amount",
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  "\$${provider.totalCartPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // NAVIGATION FIX: Go to CheckoutView
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutView()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: const Text(
                "CHECKOUT",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
