import 'package:flutter/material.dart';
import 'package:mobile_year4/services/sale_service.dart';

class SaleProvider extends ChangeNotifier {
  double _todaySales = 0.0;
  double _monthlyRevenue = 0.0;
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _saleDetails = [];

  // Getters
  double get todaySales => _todaySales;
  double get monthlyRevenue => _monthlyRevenue;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<dynamic> get saleDetails => _saleDetails;
  bool get hasNoSales => _todaySales == 0 && _monthlyRevenue == 0;

  // Method to fetch Summary
  Future<void> fetchSales() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await SaleService.getSalesSummary();

    if (result['success']) {
      _todaySales = result['today_sales'];
      _monthlyRevenue = result['monthly_revenue'];
    } else {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Method to fetch individual transactions (Details)
  Future<void> fetchSaleDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await SaleService.getDetailedSales();

    if (result['success']) {
      _saleDetails = result['data'];
    } else {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners();
  }
}
