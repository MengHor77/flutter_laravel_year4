import '../models/book_model.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onAction;
  final String buttonText;
  final Color buttonColor;

  const BookCard({
    super.key,
    required this.book,
    required this.onAction,
    required this.buttonText,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            book.imageUrl,
            width: 60,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 40),
          ),
        ),
        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${book.author}\n${book.price}"),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: Colors.white,
          ),
          onPressed: onAction,
          child: Text(buttonText),
        ),
      ),
    );
  }
}