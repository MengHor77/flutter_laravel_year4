import 'package:flutter/material.dart';
import 'package:mobile_year4/colors.dart';

class MonthlySaleCard extends StatelessWidget {
  final double amount;

  const MonthlySaleCard({super.key, required this.amount});

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
        backgroundColor: AppColors.accent,
        child: Icon(Icons.calendar_month, color: AppColors.textOnDark),
      ),
      title: const Text(
        "Monthly Revenue",
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      ),
      subtitle: Text(
        hasNoSale ? "No data" : "\$${amount.toStringAsFixed(2)}",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: hasNoSale ? AppColors.textSecondary : AppColors.accent,
        ),
      ),
    );
  }
}
