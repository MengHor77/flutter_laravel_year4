import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/book_provider.dart';
import '../../../widgets/frontent/menu_sidebar.dart';
import '../checkout_view/checkout_view.dart'; // ✅ Import CheckoutView

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BookProvider>().fetchSavedOrders());
  }

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return 'https://via.placeholder.com/150';
    if (path.startsWith('http')) return path;
    String cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return "${ApiConfig.storage}$cleanPath";
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order List"),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: provider.isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: provider.isSyncing
                ? null
                : () => provider.fetchSavedOrders(),
          ),
        ],
      ),
      drawer: const AppSidebar(currentRoute: 'Order List'),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchSavedOrders(),
        color: AppColors.accent,
        child: provider.isSyncing && provider.cart.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : provider.cart.isEmpty
            ? const Center(child: Text("Your cart is empty"))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: provider.cart.length,
                itemBuilder: (context, index) {
                  final item = provider.cart[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            _getImageUrl(item.image),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.book, color: Colors.grey),
                          ),
                        ),
                      ),
                      title: Text(item.name, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        "\$${item.displayPrice}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              ScaffoldMessenger.of(
                                context,
                              ).removeCurrentSnackBar();
                              await provider.decrementQuantity(index);
                            },
                          ),
                          Text(
                            "${item.quantity}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.blue,
                            ),
                            onPressed: () async {
                              ScaffoldMessenger.of(
                                context,
                              ).removeCurrentSnackBar();
                              await provider.addToCart(item);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: provider.cart.isEmpty ? null : _buildTotal(provider),
    );
  }

  Widget _buildTotal(BookProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total: \$${provider.totalCartPrice.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
              ),
              onPressed: () {
                // ✅ NAVIGATION FIX: Navigate to CheckoutView
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CheckoutView()),
                );
              },
              child: const Text(
                "check out",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
