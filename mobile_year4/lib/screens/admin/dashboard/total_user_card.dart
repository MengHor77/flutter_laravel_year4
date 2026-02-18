import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TotalUserCard extends StatelessWidget {
  const TotalUserCard({super.key});

  // --- KEEP OLD CODE: Logic remains exactly the same ---
  Future<String> _fetchTotal() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.users),
        headers: ApiConfig.getHeaders(),
      );
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.length.toString();
      }
    } catch (e) {
      debugPrint("Dashboard User Error: $e");
      return "0";
    }
    return "0";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchTotal(),
      builder: (context, snapshot) {
        return _DashboardItem(
          title: "Total Users",
          value: snapshot.hasData ? snapshot.data! : "...",
          icon: Icons.people,
          color: AppColors.success,
        );
      },
    );
  }
}

class _DashboardItem extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;

  const _DashboardItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // MODERNIZED: White background with your lightGray border
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.lightGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with the tinted background circle to match your theme
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary, // Swapped to secondary for depth
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
