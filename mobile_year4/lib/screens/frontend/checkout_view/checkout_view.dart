import '../../../colors.dart';
import '../home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/book_provider.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  bool _isProcessing = false;

  // Helper function to handle potential symbol issues in price strings
  double _parseSafePrice(String price) {
    final cleanPrice = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }

  void _handlePayment(BuildContext context) async {
    setState(() => _isProcessing = true);

    final provider = context.read<BookProvider>();
    bool success = await provider.processCheckout();

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (success) {
      _showSuccessDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Checkout Failed. Please check your connection."),
          backgroundColor: AppColors.danger, // Use AppColors.danger (red)
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 60,
        ), // Use AppColors.success
        content: const Text(
          "Order Placed Successfully!",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog

              // FIX: Using MaterialPageRoute to go to HomeView safely
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeView()),
                (route) => false, // Clears the navigation stack
              );
            },
            child: const Text("OK", style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();

    return Scaffold(
      backgroundColor: AppColors.background, 
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnDark, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const Divider(),
            Expanded(
              child: provider.cart.isEmpty
                  ? const Center(
                      child: Text(
                        "No items in cart",
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      itemCount: provider.cart.length,
                      itemBuilder: (context, index) {
                        final item = provider.cart[index];

                        double unitPrice = _parseSafePrice(
                          item.displayPrice.toString(),
                        );
                        double subtotal = unitPrice * item.quantity;

                        return ListTile(
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          subtitle: Text(
                            "Qty: ${item.quantity}",
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          trailing: Text(
                            "\$${subtotal.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  "\$${provider.totalCartPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success, 
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.textOnDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isProcessing ? null : () => _handlePayment(context),
                child: _isProcessing
                    ? const CircularProgressIndicator(
                        color: AppColors.textOnDark,
                      )
                    : const Text(
                        "CONFIRM AND PAY",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
