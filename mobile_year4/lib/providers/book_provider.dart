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
  List<Book> _freeBooks = []; // State for Free Books

  String get userName => _userName;
  String get userEmail => _userEmail;
  List<Book> get cart => List.unmodifiable(_cart);
  List<Book> get freeBooks => List.unmodifiable(_freeBooks); // Getter

  int get itemCount => _cart.length;
  bool get isSyncing => _isSyncing;

  void setUser(String name, String email, [String? token]) {
    _userName = name;
    _userEmail = email;
    if (token != null) ApiConfig.userToken = token;
    notifyListeners();
  }

  // Calculate total price locally
  double get totalCartPrice {
    return _cart.fold(0.0, (sum, item) {
      final String priceString = item.displayPrice.toString().replaceAll(
        RegExp(r'[^0-9.]'),
        '',
      );
      return sum + ((double.tryParse(priceString) ?? 0.0) * item.quantity);
    });
  }

  Future<void> fetchSavedOrders() async {
    _isSyncing = true;
    notifyListeners();
    try {
      final response = await BookService.fetchCart();
      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);

        List<dynamic> rawData = [];
        if (decodedData is List) {
          rawData = decodedData;
        } else if (decodedData is Map) {
          rawData = decodedData['data'] ?? (decodedData['orders'] ?? []);
        }

        _cart.clear();
        for (var item in rawData) {
          var bookObj = item['book'] ?? item;

          if (bookObj != null && bookObj['id'] != null) {
            final Map<String, dynamic> bookData = Map<String, dynamic>.from(
              bookObj,
            );

            bookData['display_price'] = (item['price'] ?? bookObj['price'])
                .toString();
            bookData['quantity'] = item['quantity'] ?? 1;

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

    if (ApiConfig.userToken == null) return;

    try {
      final String cleanPrice = book.displayPrice.toString().replaceAll(
        RegExp(r'[^0-9.]'),
        '',
      );
      final response = await BookService.addToCart(book.id, cleanPrice);

      if (response.statusCode == 201 || response.statusCode == 200) {
        debugPrint("✅ [SERVER CART] Sync Success");
      }
    } catch (e) {
      debugPrint("❌ Sync Error: $e");
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
      await BookService.decrement(bookId);
    } catch (e) {
      debugPrint("Network Error: $e");
    }
  }

  void logout() {
    _userName = "Guest User";
    _userEmail = "guest@example.com";
    ApiConfig.userToken = null;
    _cart.clear();
    notifyListeners();
  }

  Future<bool> processCheckout() async {
    if (ApiConfig.userToken == null || _cart.isEmpty) return false;
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
        _cart.clear();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("❌ Checkout Exception: $e");
      return false;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // 1. Fetch
  Future<void> fetchFreeBooks() async {
    _isSyncing = true;
    notifyListeners();
    try {
      final response = await BookService.fetchFreeBooks();
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _freeBooks = data.map((json) => Book.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching free books: $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // 2. Add (Create)
  Future<bool> addFreeBook(Map<String, dynamic> data) async {
    _isSyncing = true;
    notifyListeners();
    try {
      final response = await BookService.storeFreeBook(data);
      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchFreeBooks(); // Refresh list
        return true;
      }
    } catch (e) {
      debugPrint("Add Error: $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
    return false;
  }

  // 3. Update
  Future<bool> updateFreeBook(String id, Map<String, dynamic> data) async {
    _isSyncing = true;
    notifyListeners();
    try {
      final response = await BookService.updateFreeBook(id, data);
      if (response.statusCode == 200) {
        await fetchFreeBooks(); // Refresh list
        return true;
      }
    } catch (e) {
      debugPrint("Update Error: $e");
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
    return false;
  }

 // 4. Delete Free Book Logic
  Future<bool> deleteFreeBook(String id) async {
    try {
      final response = await BookService.deleteFreeBook(id);
      
      if (response.statusCode == 200) {
        // Find and remove locally so the UI rebuilds with the correct length
        _freeBooks.removeWhere((book) => book.id == id);
        
        // This notifies the Consumer/ListView.builder to redraw
        notifyListeners(); 
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Delete Error: $e");
      return false;
    }
  }
}
