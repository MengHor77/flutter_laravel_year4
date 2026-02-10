import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mobile_year4/colors.dart';

class SaleDetailItem extends StatelessWidget {
  final dynamic sale;
  const SaleDetailItem({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    // 1. SAFELY extract objects
    final book = sale['book'];
    final user = sale['user'];

    // 2. FIXED LINES: Create safe String variables using '??'
    // This prevents "type 'Null' is not a subtype of type 'String'"
    final String bookTitle = book != null
        ? (book['name'] ?? "Unknown Book")
        : "Deleted Book";
    final String userName = user != null
        ? (user['name']?.toString() ?? "Guest User")
        : "Unknown User";

    // 3. SAFE DATE HANDLING
    String formattedDate = "Date N/A";
    if (sale['created_at'] != null) {
      try {
        DateTime date = DateTime.parse(sale['created_at'].toString());
        formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);
      } catch (e) {
        formattedDate = "Invalid Date";
      }
    }

    return Card(
      elevation: 0,
      color: AppColors.cardBg,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.receipt_long, color: AppColors.accent),
        ),
        title: Text(
          bookTitle, // Safe variable
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Safe String interpolation
            Text(
              "Customer: $userName",
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),

            Text(
              formattedDate,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),

            // Safe numeric handling with fallbacks
            Text(
              "Qty: ${sale['quantity'] ?? 0} × \$${sale['price'] ?? '0.00'}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        trailing: Text(
          // Ensure total_amount is never null
          "\$${sale['total_amount']?.toString() ?? '0.00'}",
          style: const TextStyle(
            color: AppColors.success,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
