import 'package:flutter/material.dart';
import 'package:mobile_year4/colors.dart';

class TodaySaleCard extends StatelessWidget {
  final double amount;

  const TodaySaleCard({super.key, required this.amount});

  @override
  Widget build(BuildContext context) {
    bool hasNoSale = amount <= 0;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      tileColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      leading: const CircleAvatar(
        backgroundColor: AppColors.success,
        child: Icon(Icons.today, color: AppColors.textOnDark),
      ),
      title: const Text(
        "Today's Total Sale",
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
      subtitle: Text(
        hasNoSale ? "No sale yet" : "\$${amount.toStringAsFixed(2)}",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: hasNoSale ? AppColors.textSecondary : AppColors.success,
        ),
      ),
    );
  }
}
