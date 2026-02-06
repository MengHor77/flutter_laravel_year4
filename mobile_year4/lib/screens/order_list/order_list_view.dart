import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../colors.dart'; // Import your colors
import '../../widgets/frontent/menu_sidebar.dart';

class OrderListView extends StatelessWidget {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<BookProvider>().cart;

    return Scaffold(
      backgroundColor: AppColors.background, // Use theme background
      appBar: AppBar(
        title: const Text("Order List"),
        backgroundColor: AppColors.primary, // Use Navy Primary
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
          ? const  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                   SizedBox(height: 16),
                  Text(
                    "Your order list is empty.",
                    style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
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
                  color: AppColors.cardBg,
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: Container(
                      width: 50,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // Since Laravel doesn't have imageUrl yet, we show an icon
                      child: const Icon(Icons.book, color: AppColors.accent),
                    ),
                    title: Text(
                      item.name, // FIXED: Changed 'title' to 'name'
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      "\$${item.price}", // Displays the price string
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_sweep, color: AppColors.danger),
                      onPressed: () {
                        context.read<BookProvider>().removeFromCart(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${item.name} removed"), // FIXED: 'name'
                            backgroundColor: AppColors.primary,
                          ),
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