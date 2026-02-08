import 'dart:async';
import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActiveOrderCard extends StatelessWidget {
  const ActiveOrderCard({super.key});

  Future<String> _fetchTotal() async {
    // 1. Check if token exists before trying to fetch
    if (ApiConfig.userToken == null) {
      return "0";
    }

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.orders),
        // 2. CRITICAL: You must pass headers to get private user data
        headers: ApiConfig.getHeaders(), 
      );

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        
        // Return the number of items in the order list
        return data.length.toString();
      } else {
        debugPrint("Order Fetch Error: ${response.statusCode}");
        return "0";
      }
    } catch (e) {
      debugPrint("Connection Error in ActiveOrderCard: $e");
      return "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchTotal(),
      builder: (context, snapshot) {
        // Handle loading state
        String displayValue = "...";
        if (snapshot.connectionState == ConnectionState.done) {
          displayValue = snapshot.data ?? "0";
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart, size: 40, color: AppColors.warning),
              const SizedBox(height: 8),
              Text(
                displayValue,
                style: const TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary, // Ensure this exists in your colors.dart
                ),
              ),
              const Text(
                "Active Orders",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}