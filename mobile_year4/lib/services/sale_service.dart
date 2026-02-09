import 'dart:convert';
import 'package:http/http.dart' as http; 
import 'package:mobile_year4/api_config.dart';

class SaleService {
  static Future<Map<String, dynamic>> getSalesSummary() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.sales),
        headers: ApiConfig.getHeaders(),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        
        return {
          'success': true,
          'today_sales': decodedData['today_sales']?.toDouble() ?? 0.0,
          'monthly_revenue': decodedData['monthly_revenue']?.toDouble() ?? 0.0,
        };
      } else {
        return {
          'success': false,
          'message': 'Server returned error: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection failed: $e',
      };
    }
  }
}