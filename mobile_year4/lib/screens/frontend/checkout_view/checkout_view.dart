import '../../../colors.dart';
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
        const SnackBar(content: Text("Checkout Failed. Try again."), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: const Text("Order Placed Successfully!", textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacementNamed(context, '/home'); 
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout"), backgroundColor: AppColors.accent),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Order Summary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: provider.cart.length,
                itemBuilder: (context, index) {
                  final item = provider.cart[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text("Qty: ${item.quantity}"),
                    trailing: Text("\$${(double.parse(item.displayPrice) * item.quantity).toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text("\$${provider.totalCartPrice.toStringAsFixed(2)}", 
                     style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
                onPressed: _isProcessing ? null : () => _handlePayment(context),
                child: _isProcessing 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("CONFIRM AND PAY", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            )
          ],
        ),
      ),
    );
  }
}