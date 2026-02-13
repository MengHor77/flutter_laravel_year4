import 'package:flutter/material.dart';
import 'package:mobile_year4/services/sale_service.dart';

class SaleProvider extends ChangeNotifier {
  double _todaySales = 0.0;
  double _monthlyRevenue = 0.0;
  bool _isLoading = false;
  String? _errorMessage;
  List<dynamic> _saleDetails = [];

  double get todaySales => _todaySales;
  double get monthlyRevenue => _monthlyRevenue;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<dynamic> get saleDetails => _saleDetails;
  bool get hasNoSales => _todaySales == 0 && _monthlyRevenue == 0;

  Future<void> refreshAll() async {
    debugPrint("🔄 [SALE PROVIDER] Refreshing all data...");
    await fetchSales();
    await fetchSaleDetails();
  }

  Future<void> fetchSales() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await SaleService.getSalesSummary();

    if (result['success']) {
      _todaySales = (result['today_sales'] ?? 0).toDouble();
      _monthlyRevenue = (result['monthly_revenue'] ?? 0).toDouble();
      debugPrint("✅ [SALE SUMMARY] Success: Revenue fetched.");
    } else {
      _errorMessage = result['message'];
      debugPrint("❌ [SALE SUMMARY] Error: $_errorMessage");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSaleDetails() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await SaleService.getDetailedSales();

    if (result['success']) {
      _saleDetails = result['data'] ?? [];
      debugPrint(
        "✅ [SALE DETAILS] Success: ${_saleDetails.length} transactions found.",
      );
    } else {
      _errorMessage = result['message'];
      debugPrint("❌ [SALE DETAILS] Error: $_errorMessage");
    }

    _isLoading = false;
    notifyListeners();
  }
}
