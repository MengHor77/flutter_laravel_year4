import '../../../colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/sale_provider.dart';

class TotalMonthlyOrderCard extends StatelessWidget {
  const TotalMonthlyOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Using Consumer to listen to SaleProvider
    return Consumer<SaleProvider>(
      builder: (context, saleProvider, child) {
        // 1. GET CURRENT DATE
        final now = DateTime.now();

        // 2. FILTER TRANSACTIONS FOR CURRENT MONTH ONLY
        final monthlyTransactions = saleProvider.saleDetails.where((sale) {
          if (sale['created_at'] == null) return false;
          try {
            DateTime saleDate = DateTime.parse(sale['created_at'].toString());
            // Check if year and month match today's date
            return saleDate.year == now.year && saleDate.month == now.month;
          } catch (e) {
            return false;
          }
        }).toList();

        // 3. SET DISPLAY VALUE
        String displayValue = saleProvider.isLoading
            ? "..."
            : monthlyTransactions.length.toString();

        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_cart,
                size: 40,
                color: AppColors.warning,
              ),
              const SizedBox(height: 8),
              Text(
                displayValue,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Text(
                "Monthly Orders",
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}
