import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/special_offers_service.dart';

class SpecialOffersProvider extends ChangeNotifier {
  List _offers = [];
  bool _isLoading = true;

  List get offers => _offers;
  bool get isLoading => _isLoading;

  Future<void> fetchOffers() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await SpecialOffersService.fetchOffers();
      if (response.statusCode == 200) {
        _offers = json.decode(response.body);
      }
    } catch (e) {
      debugPrint("Error fetching offers: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
