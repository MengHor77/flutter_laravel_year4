import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/sale_provider.dart';
import '../../../colors.dart'; // Ensure this path is correct

class RevenueCard extends StatelessWidget {
  const RevenueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SaleProvider>(
      builder: (context, saleProvider, child) {
        // We use Container instead of Card for better control over the modern look
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg, // Using your white cardBg
            borderRadius: BorderRadius.circular(20), // Modern rounded corners
            border: Border.all(
              color: AppColors.lightGray, // Using your new lightGray border
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05), // Subtle shadow
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon wrapped in a tinted circle for a premium feel
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(
                    alpha: 0.1,
                  ), // 10% purple tint
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.monetization_on,
                  size: 32,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 16),

              // --- YOUR ORIGINAL LOGIC KEPT HERE ---
              Text(
                "\$${saleProvider.monthlyRevenue.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary, // Matching your text config
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Total Revenue",
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
