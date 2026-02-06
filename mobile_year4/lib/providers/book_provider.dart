import '../models/book_model.dart';
import 'package:flutter/material.dart';

class BookProvider extends ChangeNotifier {
  /// The internal list of books added to the cart/order.
  final List<Book> _cart = [];

  /// Returns an unmodifiable list of the cart items to prevent direct manipulation.
  List<Book> get cart => List.unmodifiable(_cart);

  /// Returns the count of items in the cart (useful for badges).
  int get itemCount => _cart.length;

  /// Logic to add a book to the cart.
  void addToCart(Book book) {
    // Check by ID to prevent duplicates
    bool isAlreadyInCart = _cart.any((item) => item.id == book.id);

    if (!isAlreadyInCart) {
      _cart.add(book);
      notifyListeners(); // Updates all listening UI widgets
    }
  }

  /// Logic to remove a book from the cart by its index.
  void removeFromCart(int index) {
    if (index >= 0 && index < _cart.length) {
      _cart.removeAt(index);
      notifyListeners();
    }
  }

  /// Logic to clear the entire cart after a successful purchase.
  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  /// Helper to calculate the total price of all items in the cart.
  /// It converts the String price to a double safely.
  double get totalCartPrice {
    return _cart.fold(0.0, (sum, item) {
      // Handles cases where price might contain currency symbols like '$'
      final cleanPrice = item.price.replaceAll(RegExp(r'[^0-9.]'), '');
      return sum + (double.tryParse(cleanPrice) ?? 0.0);
    });
  }
}
