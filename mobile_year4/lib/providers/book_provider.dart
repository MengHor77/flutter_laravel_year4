import 'dart:convert';
import '../api_config.dart';
import '../models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookProvider extends ChangeNotifier {
  final List<Book> _cart = [];
  bool _isSyncing = false;

  List<Book> get cart => List.unmodifiable(_cart);
  int get itemCount => _cart.length;
  bool get isSyncing => _isSyncing;

  /// 1. Fetch saved orders from Laravel on startup
  Future<void> fetchSavedOrders() async {
    _isSyncing = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiConfig.orders),
        headers: ApiConfig.getHeaders(),
      );

      if (response.statusCode == 200) {
        final List rawData = jsonDecode(response.body);
        _cart.clear();
        for (var item in rawData) {
          // Laravel returns the book inside the 'book' relation
          if (item['book'] != null) {
            _cart.add(Book.fromJson(item['book']));
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching saved orders: $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  /// 2. Add a book to cart and Laravel Database
  Future<void> addToCart(Book book) async {
    if (_cart.any((item) => item.id == book.id)) return;

    // Local Update
    _cart.add(book);
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.orders),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({
          "book_id": book.id, 
          "price": book.price
        }),
      );

      if (response.statusCode != 201) {
        debugPrint("Server Error adding book: ${response.body}");
      }
    } catch (e) {
      debugPrint("Network Error: $e");
    }
  }

  /// 3. Remove a book by index and Delete from Laravel Database
  Future<void> removeFromCart(int index) async {
    if (index >= 0 && index < _cart.length) {
      final bookId = _cart[index].id;

      // Local Update
      _cart.removeAt(index);
      notifyListeners();

      try {
        final response = await http.delete(
          Uri.parse("${ApiConfig.orders}/$bookId"),
          headers: ApiConfig.getHeaders(),
        );

        if (response.statusCode != 200) {
          debugPrint("Server Error deleting book: ${response.body}");
        }
      } catch (e) {
        debugPrint("Network Error: $e");
      }
    }
  }

  /// Helper to calculate total price
  double get totalCartPrice {
    return _cart.fold(0.0, (sum, item) {
      final cleanPrice = item.price.toString().replaceAll(RegExp(r'[^0-9.]'), '');
      return sum + (double.tryParse(cleanPrice) ?? 0.0);
    });
  }
}