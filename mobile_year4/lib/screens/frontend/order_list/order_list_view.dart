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
    // ហៅទិន្នន័យនៅពេលទំព័រត្រូវបានបង្កើត
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

    //  លុប Scaffold ចេញ ហើយប្រើ Column ឬ Stack ដើម្បីបង្ហាញទិន្នន័យ
    //  ព្រោះ AppBar ត្រូវបានគ្រប់គ្រងដោយ MainWrapper រួចជាស្រេច
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
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
                          title: Text(
                            item.name,
                            overflow: TextOverflow.ellipsis,
                          ),
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
        ),
        //  បង្ហាញ Total Section នៅខាងក្រោម List តែស្ថិតក្នុង Body របស់ MainWrapper
        if (provider.cart.isNotEmpty) _buildTotal(provider),
      ],
    );
  }

  Widget _buildTotal(BookProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              // សម្រាប់ការទៅកាន់ Checkout យើងប្រើ Navigator.push ធម្មតា
              // វានឹងបើក Page ថ្មីពីលើ (Full Screen) ដែលជាចំណង់ចំណូលចិត្តទូទៅសម្រាប់ទំព័របង់ប្រាក់
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
