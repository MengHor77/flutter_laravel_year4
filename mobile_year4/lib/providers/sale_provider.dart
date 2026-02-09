import 'package:flutter/material.dart';
import 'package:mobile_year4/services/sale_service.dart';

class SaleProvider extends ChangeNotifier {
  double _todaySales = 0.0;
  double _monthlyRevenue = 0.0;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  double get todaySales => _todaySales;
  double get monthlyRevenue => _monthlyRevenue;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Check if no sales exist
  bool get hasNoSales => _todaySales == 0 && _monthlyRevenue == 0;

  Future<void> fetchSales() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Tell the UI to show loading spinner

    final result = await SaleService.getSalesSummary();

    if (result['success']) {
      _todaySales = result['today_sales'];
      _monthlyRevenue = result['monthly_revenue'];
    } else {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners(); // Tell the UI to update with new data
  }
}
