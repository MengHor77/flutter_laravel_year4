import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TotalUserCard extends StatelessWidget {
  const TotalUserCard({super.key});

  Future<String> _fetchTotal() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.users),
        headers: ApiConfig.getHeaders(), // Ensure headers are included
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
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(15),
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
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}