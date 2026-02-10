import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/sale_provider.dart';

class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SaleProvider>(
      builder: (context, saleProvider, child) {
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.monetization_on, size: 40, color: Colors.purple),
              // This reads the _monthlyRevenue from your SaleProvider
              Text(
                "\$${saleProvider.monthlyRevenue.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text("Monthly Revenue"),
            ],
          ),
        );
      },
    );
  }
}
