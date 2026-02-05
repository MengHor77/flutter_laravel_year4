import '../models/book_model.dart';
import 'package:flutter/material.dart';

class BookProvider extends ChangeNotifier {
  final List<Book> _books = [
    Book(id: '1', title: 'Flutter Development', author: 'Google Experts', price: 'FREE', imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmf4NlFls31qGMTqzjbaNgxmoNwClN9140-A&s'),
    Book(id: '2', title: 'Dart Programming', author: 'Nita Vann', price: '\$15.00', imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6-mXGvC6eS8jOa3-rWvD6v_J-r5G8v_9XwA&s'),
    Book(id: '3', title: 'Advanced Mobile', author: 'Nita Vann', price: '\$20.00', imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT6-mXGvC6eS8jOa3-rWvD6v_J-r5G8v_9XwA&s'),
  ];

  final List<Book> _cart = [];

  List<Book> get books => List.unmodifiable(_books);
  List<Book> get cart => List.unmodifiable(_cart);

  void addToCart(Book book) {
    if (!_cart.contains(book)) {
      _cart.add(book);
      notifyListeners(); // Updates all UI screens
    }
  }

  void removeFromCart(int index) {
    _cart.removeAt(index);
    notifyListeners(); // Refreshes the Order List
  }
}