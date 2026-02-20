import 'dart:async';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../checkout_view/checkout_view.dart';
import '../../../providers/book_provider.dart';

class OrderListView extends StatefulWidget {
  const OrderListView({super.key});

  @override
  State<OrderListView> createState() => _OrderListViewState();
}

class _OrderListViewState extends State<OrderListView> {
  @override
  void initState() {
    super.initState();
    // Fetch data when page is created
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
    debugPrint("Cart Length: ${provider.cart.length}");
    debugPrint("Is Syncing: ${provider.isSyncing}");
    // Detect if dark mode is active
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: AppColors.getBackground(isDark), // Dynamic Background
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => provider.fetchSavedOrders(),
              color: AppColors.accent,
              child: provider.isSyncing && provider.cart.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : provider.cart.isEmpty
                  ? Center(
                      child: Text(
                        "Your cart is empty",
                        style: TextStyle(
                          color: AppColors.getTextSecondary(isDark),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: provider.cart.length,
                      itemBuilder: (context, index) {
                        final item = provider.cart[index];
                        return Card(
                          elevation: 2,
                          color: AppColors.getCardBg(
                            isDark,
                          ), // Dynamic Card Color
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.getBorder(isDark),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 70,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  _getImageUrl(item.image),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.book,
                                        color: Colors.grey,
                                      ),
                                ),
                              ),
                            ),
                            title: Text(
                              item.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.getTextPrimary(
                                  isDark,
                                ), // Dynamic Text
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "\$${item.displayPrice}",
                              style: TextStyle(
                                color: AppColors.getSuccess(
                                  isDark,
                                ), // Dynamic Success Color
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove_circle_outline,
                                    color: AppColors.getDanger(isDark),
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
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.getTextPrimary(isDark),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.accent,
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
          ),
          if (provider.cart.isNotEmpty) _buildTotal(provider, isDark),
        ],
      ),
    );
  }

  Widget _buildTotal(BookProvider provider, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.getCardBg(isDark), // Dynamic Bottom Bar
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total: \$${provider.totalCartPrice.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.getTextPrimary(isDark),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CheckoutView()),
              );
            },
            child: const Text(
              "Check Out",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
