import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TotalBookCard extends StatelessWidget {
  const TotalBookCard({super.key});

  // Keeping your original logic exactly as it was
  Future<String> _fetchTotal() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.books));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.length.toString();
      }
    } catch (e) {
      return "0";
    }
    return "0";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchTotal(),
      builder: (context, snapshot) {
        return _StatCard(
          title: "Total Books",
          value: snapshot.data ?? "...",
          icon: Icons.library_books,
          color: AppColors.accent, // Using your original accent color
        );
      },
    );
  }
}

// Internal reusable card widget
class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // Using your newly defined AppColors.cardBg for a clean look
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
        // Adding the subtle border with lightGray for that modern "High-End" feel
        border: Border.all(color: AppColors.lightGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            // Using the new .withValues syntax for modern Flutter standards
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with your logic
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary, // Ensuring consistent text color
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary, // Using your secondary text color
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
