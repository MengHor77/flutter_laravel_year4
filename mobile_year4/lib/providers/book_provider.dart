import 'dart:convert';
import '../api_config.dart';
import '../models/book_model.dart';
import 'package:flutter/material.dart';
import '../services/book_service.dart';

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

  // 1. Set User
  void setUser(String name, String email, [String? token]) {
    _userName = name;
    _userEmail = email;
    if (token != null) ApiConfig.userToken = token;
    notifyListeners();
  }

  // 2. Fetch Saved Orders (Sync Cart)
  Future<void> fetchSavedOrders() async {
    _isSyncing = true;
    notifyListeners();
    try {
      final response = await BookService.fetchCart();
      if (response.statusCode == 200) {
        final List rawData = jsonDecode(response.body);
        _cart.clear();
        for (var item in rawData) {
          if (item['book'] != null) {
            final Map<String, dynamic> bookData = Map<String, dynamic>.from(
              item['book'],
            );
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

  // 3. Add to Cart (LOGS ADDED)
  Future<void> addToCart(Book book) async {
    final existingIndex = _cart.indexWhere((item) => item.id == book.id);
    if (existingIndex != -1) {
      _cart[existingIndex].quantity++;
    } else {
      _cart.add(book);
    }
    notifyListeners();

    // Debug Log for Local Cart Success
    debugPrint(
      "🛒 [LOCAL CART] Added Success: ${book.name} (Qty: ${book.quantity})",
    );

    if (ApiConfig.userToken == null) return;
    try {
      final String cleanPrice = book.displayPrice.toString().replaceAll(
        RegExp(r'[^0-9.]'),
        '',
      );
      final response = await BookService.addToCart(book.id, cleanPrice);

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Debug Log for Server Sync Success
        debugPrint("✅ [SERVER CART] Sync Success for: ${book.name}");
      } else {
        debugPrint("❌ DB ERROR: ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ Connection Error: $e");
    }
  }

  // 4. Decrement Quantity
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
      await BookService.decrement(bookId);
    } catch (e) {
      debugPrint("Network Error: $e");
    }
  }

  // 5. Remove From Cart
  Future<void> removeFromCart(int index) async {
    if (index >= 0 && index < _cart.length) {
      final bookId = _cart[index].id;
      _cart.removeAt(index);
      notifyListeners();
      try {
        await BookService.delete(bookId);
      } catch (e) {
        debugPrint("Network Error: $e");
      }
    }
  }

  // 6. Total Price Calculation
  double get totalCartPrice {
    return _cart.fold(0.0, (sum, item) {
      final String priceString = item.displayPrice.toString().replaceAll(
        RegExp(r'[^0-9.]'),
        '',
      );
      return sum + ((double.tryParse(priceString) ?? 0.0) * item.quantity);
    });
  }

  // 7. Logout
  void logout() {
    _userName = "Guest User";
    _userEmail = "guest@example.com";
    ApiConfig.userToken = null;
    _cart.clear();
    notifyListeners();
  }

  // 8. Process Checkout (LOGS ADDED)
  Future<bool> processCheckout() async {
    if (ApiConfig.userToken == null || _cart.isEmpty) {
      debugPrint("⚠️ Checkout aborted: Token null or Cart empty");
      return false;
    }
    _isSyncing = true;
    notifyListeners();
    try {
      final Map<String, dynamic> checkoutData = {
        "total_amount": totalCartPrice,
        "items": _cart.map((item) {
          final String cleanPrice = item.displayPrice.toString().replaceAll(
            RegExp(r'[^0-9.]'),
            '',
          );
          double priceValue = double.tryParse(cleanPrice) ?? 0.0;
          return {
            "book_id": int.parse(item.id),
            "quantity": item.quantity,
            "price": priceValue,
            "total_amount": priceValue * item.quantity,
          };
        }).toList(),
      };

      final response = await BookService.checkout(checkoutData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Debug Log for Payment Success
        debugPrint(
          "✅[PAYMENT SUCCESS] Total Paid: \$${totalCartPrice.toStringAsFixed(2)}",
        );
        debugPrint("Response: ${response.body}");

        _cart.clear();
        notifyListeners();
        return true;
      } else {
        debugPrint(
          "❌ [PAYMENT FAILED] Status: ${response.statusCode} Body: ${response.body}",
        );
        return false;
      }
    } catch (e) {
      debugPrint("❌ Checkout Exception: $e");
      return false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }
}
