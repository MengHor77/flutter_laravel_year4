import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_year4/api_config.dart';

class SaleService {
  // Existing method (Summary)
  static Future<Map<String, dynamic>> getSalesSummary() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.sales),
        headers: ApiConfig.getHeaders(),
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return {
          'success': true,
          'today_sales': decodedData['today_sales']?.toDouble() ?? 0.0,
          'monthly_revenue': decodedData['monthly_revenue']?.toDouble() ?? 0.0,
        };
      }
      return {'success': false, 'message': 'Error: ${response.statusCode}'};
    } catch (e) {
      return {'success': false, 'message': 'Connection failed: $e'};
    }
  }

  // NEW method (Details)
  static Future<Map<String, dynamic>> getDetailedSales() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.saleDetails),
        headers: ApiConfig.getHeaders(),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        return {
          'success': true,
          'data': decoded['data'] ?? [], // This is the list of all sales
        };
      }
      return {'success': false, 'message': 'Failed to load details'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
