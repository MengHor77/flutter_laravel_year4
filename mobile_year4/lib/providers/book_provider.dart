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

  void setUser(String name, String email) {
    _userName = name;
    _userEmail = email;
    notifyListeners(); // This tells the Sidebar to refresh with the new name
  }


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

      // Inside fetchSavedOrders() in BookProvider.dart
      if (response.statusCode == 200) {
        final List rawData = jsonDecode(response.body);
        _cart.clear();
        for (var item in rawData) {
          if (item['book'] != null) {
            // Create a clean map from the nested book object
            final Map<String, dynamic> bookData = Map<String, dynamic>.from(
              item['book'],
            );

            // Inject the current price and quantity from the order_list pivot
            bookData['display_price'] = item['price'];
            bookData['quantity'] = item['quantity'];

            // The Book.fromJson will now receive the image URL exactly as it is in the DB
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

  /// 2. ADD / PLUS LOGIC
  /// Increments quantity locally and syncs with Laravel store()
  Future<void> addToCart(Book book) async {
    final existingIndex = _cart.indexWhere((item) => item.id == book.id);

    if (existingIndex != -1) {
      // If exists, increment local quantity
      _cart[existingIndex].quantity++;
    } else {
      // If new, add to cart
      _cart.add(book);
    }
    notifyListeners();

    try {
      // Laravel store() logic handles incrementing the DB record
      final response = await http.post(
        Uri.parse(ApiConfig.orders),
        headers: ApiConfig.getHeaders(),
        body: jsonEncode({"book_id": book.id, "price": book.displayPrice}),
      );

      if (response.statusCode != 201) {
        debugPrint("Server Error updating cart: ${response.body}");
      }
    } catch (e) {
      debugPrint("Network Error: $e");
    }
  }

  /// 3. SUBTRACT / MINUS LOGIC
  /// Decrements quantity locally and syncs with Laravel decrementQuantity()
  Future<void> decrementQuantity(int index) async {
    if (index < 0 || index >= _cart.length) return;

    final book = _cart[index];
    final bookId = book.id;

    if (book.quantity > 1) {
      book.quantity--;
      notifyListeners();
    } else {
      // If quantity is 1, remove it entirely
      _cart.removeAt(index);
      notifyListeners();
    }

    try {
      // This matches the decrementQuantity route in your Laravel Controller
      final response = await http.post(
        Uri.parse("${ApiConfig.orders}/decrement/$bookId"),
        headers: ApiConfig.getHeaders(),
      );

      if (response.statusCode != 200) {
        debugPrint("Server Error decrementing: ${response.body}");
      }
    } catch (e) {
      debugPrint("Network Error: $e");
    }
  }

  /// 4. REMOVE LOGIC (Trash Icon)
  /// Deletes the entire record regardless of quantity
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

  /// Helper to calculate total price (Price * Quantity)
  
  double get totalCartPrice {

    return _cart.fold(0.0, (sum, item) {
      final cleanPrice = item.displayPrice.replaceAll(RegExp(r'[^0-9.]'), '');
      final double priceValue = double.tryParse(cleanPrice) ?? 0.0;
      return sum + (priceValue * item.quantity); // Dynamic total
    });
  }

  void logout() {
  _userName = "Guest User";
  _userEmail = "guest@example.com";
  _cart.clear();
  notifyListeners();
}

}

