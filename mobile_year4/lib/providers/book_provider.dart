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

  // FIX: Added token parameter here
  void setUser(String name, String email, [String? token]) {
    _userName = name;
    _userEmail = email;
    if (token != null) {
      ApiConfig.userToken = token; // Store it globally
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
            final Map<String, dynamic> bookData = Map<String, dynamic>.from(
              item['book'],
            );
            // Inject pivot data from order_list table
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
    final existingIndex = _cart.indexWhere((item) => item.id == book.id);

    if (existingIndex != -1) {
      _cart[existingIndex].quantity++;
    } else {
      _cart.add(book);
    }
    notifyListeners();

    try {
      await http.post(
        Uri.parse(ApiConfig.orders),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({"book_id": book.id, "price": book.displayPrice}),
      );
    } catch (e) {
      debugPrint("Network Error: $e");
    }
  }

  Future<void> decrementQuantity(int index) async {
    if (index < 0 || index >= _cart.length) return;

    final book = _cart[index];
    final bookId = book.id;

    if (book.quantity > 1) {
      book.quantity--;
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

      final String priceString = item.displayPrice.toString().replaceAll(
        RegExp(r'[^0-9.]'),
        '',
      );
      final double priceValue = double.tryParse(priceString) ?? 0.0;
      return sum + (priceValue * item.quantity);
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
