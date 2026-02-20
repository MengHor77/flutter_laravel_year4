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

  void _handlePayment(BuildContext context, bool isDark) async {
    setState(() => _isProcessing = true);
    final provider = context.read<BookProvider>();
    bool success = await provider.processCheckout();

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (success) {
      _showSuccessDialog(isDark);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Checkout Failed. Please check your connection."),
          backgroundColor: AppColors.getDanger(isDark),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSuccessDialog(bool isDark) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.getCardBg(isDark), // Adaptive Dialog Bg
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Column(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.getSuccess(isDark),
              size: 60,
            ),
            const SizedBox(height: 10),
            Text(
              "Success!",
              style: TextStyle(color: AppColors.getTextPrimary(isDark)),
            ),
          ],
        ),
        content: Text(
          "Your order has been placed successfully.",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.getTextSecondary(isDark)),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
                context.read<BookProvider>().onOrderSuccess?.call(0);
              },
              child: Text(
                "Done",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.getSuccess(isDark),
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
    // Detect Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDark), // Dynamic Background
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.accent : AppColors.accentDark,
              ),
            ),
          ),

          // --- Table-style Header ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(flex: 3, child: _headerText("Product Name", isDark)),
                Expanded(
                  child: _headerText("Qty", isDark, align: TextAlign.center),
                ),
                Expanded(
                  child: _headerText("Price", isDark, align: TextAlign.center),
                ),
                Expanded(
                  child: _headerText("SubTotal", isDark, align: TextAlign.end),
                ),
              ],
            ),
          ),
          Divider(
            indent: 20,
            endIndent: 20,
            thickness: 1,
            color: AppColors.getBorder(isDark), // Dynamic Border
          ),

          // --- Items List ---
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: provider.cart.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 20, color: AppColors.getBorder(isDark)),
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
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.getTextPrimary(
                            isDark,
                          ), // Dynamic Text
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${item.quantity}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.getTextPrimary(isDark),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        unitPrice.toStringAsFixed(1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.getTextPrimary(isDark),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        subtotal.toStringAsFixed(1),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(isDark),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // --- Bottom Fixed Section ---
          _buildBottomSection(provider, isDark),
        ],
      ),
    );
  }

  Widget _headerText(
    String text,
    bool isDark, {
    TextAlign align = TextAlign.start,
  }) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.getTextSecondary(isDark), // Dynamic Header Text
        fontSize: 13,
      ),
    );
  }

  Widget _buildBottomSection(BookProvider provider, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.getCardBg(isDark), // Dynamic Surface
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : AppColors.shadow,
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
                Text(
                  "Total Payable:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(isDark),
                  ),
                ),
                Text(
                  "\$${provider.totalCartPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 28,
                    color: AppColors.getSuccess(isDark), // Dynamic Green
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
                onPressed: _isProcessing
                    ? null
                    : () => _handlePayment(context, isDark),
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
