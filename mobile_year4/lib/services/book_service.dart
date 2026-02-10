import 'dart:convert';
import '../api_config.dart';
import 'package:http/http.dart' as http;

class BookService {
  // Method 1: Fetch Cart
  static Future<http.Response> fetchCart() async {
    return await http.get(
      Uri.parse(ApiConfig.orders),
      headers: ApiConfig.getHeaders(),
    );
  }

  // Method 2: Add to DB Cart
  static Future<http.Response> addToCart(
    String bookId,
    String cleanPrice,
  ) async {
    return await http.post(
      Uri.parse(ApiConfig.orders),
      headers: ApiConfig.getHeaders(),
      body: jsonEncode({"book_id": int.parse(bookId), "price": cleanPrice}),
    );
  }

  // Method 3: Decrement
  static Future<http.Response> decrement(String bookId) async {
    return await http.post(
      Uri.parse("${ApiConfig.orders}/decrement/$bookId"),
      headers: ApiConfig.getHeaders(),
    );
  }

  // Method 4: Delete
  static Future<http.Response> delete(String bookId) async {
    return await http.delete(
      Uri.parse("${ApiConfig.orders}/$bookId"),
      headers: ApiConfig.getHeaders(),
    );
  }

  // Method 5: Checkout
  static Future<http.Response> checkout(Map<String, dynamic> data) async {
    return await http.post(
      Uri.parse("${ApiConfig.baseUrl}/api/checkout"),
      headers: ApiConfig.getHeaders(),
      body: jsonEncode(data),
    );
  }
}
