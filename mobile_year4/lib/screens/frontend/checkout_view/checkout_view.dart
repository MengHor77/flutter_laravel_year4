import 'dart:async';
import '../../../colors.dart';
import '../home/home_view.dart';
import '../../../../api_config.dart';
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

  double _parseSafePrice(dynamic price) {
    if (price == null) return 0.0;
    final cleanPrice = price.toString().replaceAll(RegExp(r'[^0-9.]'), '');
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
          backgroundColor: AppColors.danger, 
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Column(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 60,
            ), 
            SizedBox(height: 10),
            Text("Success!"),
          ],
        ),
        content: const Text(
          "Your order has been placed successfully.",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                context.read<BookProvider>().onOrderSuccess?.call(0);
              },
              child: const Text(
                "ok go to home",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ),
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
        title: const Text(
          "Checkout Summary",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
          ),

          // --- Table-style Header ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(flex: 3, child: _headerText("Product Name")),
                Expanded(child: _headerText("Qty", align: TextAlign.center)),
                Expanded(child: _headerText("Price", align: TextAlign.center)),
                Expanded(child: _headerText("SubTotal", align: TextAlign.end)),
              ],
            ),
          ),
          const Divider(
            indent: 20,
            endIndent: 20,
            thickness: 1,
            color: AppColors.border,
          ),

          // --- Items List ---
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: provider.cart.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 20, color: AppColors.border),
              itemBuilder: (context, index) {
                final item = provider.cart[index];
                double unitPrice = _parseSafePrice(item.displayPrice);
                double subtotal = unitPrice * item.quantity;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${item.quantity}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),
                    // Price Column - Updated to solid black
                    Expanded(
                      child: Text(
                        unitPrice.toStringAsFixed(1),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlack,  
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        subtotal.toStringAsFixed(1),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // --- Bottom Fixed Section ---
          _buildBottomSection(provider),
        ],
      ),
    );
  }

  Widget _headerText(String text, {TextAlign align = TextAlign.start}) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,  
        fontSize: 13,
      ),
    );
  }

  Widget _buildBottomSection(BookProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const  BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow, 
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Payable:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  "\$${provider.totalCartPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 28,
                    color: AppColors.success,  
                    fontWeight: FontWeight.w900,
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
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isProcessing ? null : () => _handlePayment(context),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "CONFIRM AND PAY",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
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
