import 'dart:convert';
import '../api_config.dart';
import '../models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookProvider extends ChangeNotifier {
  final List<Book> _cart = [];
  bool _isSyncing = false;

  String _userName = "Guest User";
  String _userEmail = "guest@example.com";

  String get userName => _userName;
  String get userEmail => _userEmail;
  List<Book> get cart => List.unmodifiable(_cart);
  int get itemCount => _cart.length;
  bool get isSyncing => _isSyncing;

  void setUser(String name, String email, [String? token]) {
    _userName = name;
    _userEmail = email;
    if (token != null) {
      ApiConfig.userToken = token;
    }
    notifyListeners();
  }

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
          if (item['book'] != null) {
            final Map<String, dynamic> bookData = Map<String, dynamic>.from(item['book']);
            bookData['display_price'] = item['price'].toString();
            bookData['quantity'] = item['quantity'];
            _cart.add(Book.fromJson(bookData));
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

  Future<void> addToCart(Book book) async {
    // 1. Local UI update
    final existingIndex = _cart.indexWhere((item) => item.id == book.id);
    if (existingIndex != -1) {
      _cart[existingIndex].quantity++;
    } else {
      _cart.add(book);
    }
    notifyListeners();

    if (ApiConfig.userToken == null) return;

    try {
      final String cleanPrice = book.displayPrice.toString().replaceAll(RegExp(r'[^0-9.]'), '');

      final response = await http.post(
        Uri.parse(ApiConfig.orders),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({
          "book_id": int.parse(book.id),
          "price": cleanPrice,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint("✅ SUCCESS: Inserted into order_list table!");
      } else {
        debugPrint("❌ DB ERROR: ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ Connection Error: $e");
    }
  }

  Future<void> decrementQuantity(int index) async {
    if (index < 0 || index >= _cart.length) return;

    final bookId = _cart[index].id;
    if (_cart[index].quantity > 1) {
      _cart[index].quantity--;
    } else {
      _cart.removeAt(index);
    }
    notifyListeners();

    try {
      await http.post(
        Uri.parse("${ApiConfig.orders}/decrement/$bookId"),
        headers: ApiConfig.getHeaders(),
      );
    } catch (e) {
      debugPrint("Network Error: $e");
    }
  }

  Future<void> removeFromCart(int index) async {
    if (index >= 0 && index < _cart.length) {
      final bookId = _cart[index].id;
      _cart.removeAt(index);
      notifyListeners();

      try {
        await http.delete(
          Uri.parse("${ApiConfig.orders}/$bookId"),
          headers: ApiConfig.getHeaders(),
        );
      } catch (e) {
        debugPrint("Network Error: $e");
      }
    }
  }

  double get totalCartPrice {
    return _cart.fold(0.0, (sum, item) {
      final String priceString = item.displayPrice.toString().replaceAll(RegExp(r'[^0-9.]'), '');
      return sum + ((double.tryParse(priceString) ?? 0.0) * item.quantity);
    });
  }

  void logout() {
    _userName = "Guest User";
    _userEmail = "guest@example.com";
    ApiConfig.userToken = null;
    _cart.clear();
    notifyListeners();
  }
}