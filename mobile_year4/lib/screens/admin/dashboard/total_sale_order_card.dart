import '../../../colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/sale_provider.dart';

class TotalSaleOrderCard extends StatelessWidget {
  const TotalSaleOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SaleProvider>(
      builder: (context, saleProvider, child) {
        final now = DateTime.now();

        // --- KEEP OLD CODE: Logic remains untouched ---
        final monthlyTransactions = saleProvider.saleDetails.where((sale) {
          if (sale['created_at'] == null) return false;
          try {
            DateTime saleDate = DateTime.parse(sale['created_at'].toString());
            return saleDate.year == now.year && saleDate.month == now.month;
          } catch (e) {
            return false;
          }
        }).toList();

        String displayValue = saleProvider.isLoading
            ? "..."
            : monthlyTransactions.length.toString();

        return Container(
          // --- MODERNIZED DESIGN ---
          decoration: BoxDecoration(
            color: AppColors.cardBg, // Use white background
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppColors.lightGray,
              width: 1.5,
            ), // Subtle border
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), // Modern shadow
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with a light warning-tinted circle
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  size: 32,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                displayValue,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Text(
                "Monthly Sales", // Slightly shortened for cleaner UI
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
