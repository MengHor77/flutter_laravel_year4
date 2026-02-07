import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key});

  Future<String> _fetchRevenue() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.orders));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        double total = 0;
        for (var item in data) {
          // Multiply price by quantity from your order_list table
          double price = double.tryParse(item['price'].toString()) ?? 0;
          int qty = int.tryParse(item['quantity'].toString()) ?? 1;
          total += (price * qty);
        }
        return "\$${total.toStringAsFixed(2)}";
      }
    } catch (e) {
      return "\$0.00";
    }
    return "\$0.00";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchRevenue(),
      builder: (context, snapshot) => Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.monetization_on, size: 40, color: Colors.purple),
            Text(
              snapshot.data ?? "...",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Revenue",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
