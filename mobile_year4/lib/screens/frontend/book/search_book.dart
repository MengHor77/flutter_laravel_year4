// import '../../../../colors.dart';
// import 'package:flutter/material.dart';
// import '../../../../models/book_model.dart';
// import '../../../../widgets/frontent/book_card.dart';

// class BookSearchDelegate extends SearchDelegate {
//   final List<Book> books;
//   final Function(Book) onAddToCart;

//   BookSearchDelegate({required this.books, required this.onAddToCart});

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () => close(context, null),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) => _buildSearchResults();

//   @override
//   Widget buildSuggestions(BuildContext context) => _buildSearchResults();

//   Widget _buildSearchResults() {
//     final results = books.where((book) {
//       final name = book.name.toLowerCase();
//       final author = (book.author ?? '').toLowerCase();
//       final price = book.price.toString().toLowerCase();
//       final search = query.toLowerCase();

//       return name.contains(search) ||
//           author.contains(search) ||
//           price.contains(search);
//     }).toList();

//     if (results.isEmpty) {
//       return const Center(child: Text("No books found."));
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(12),
//       itemCount: results.length,
//       itemBuilder: (context, index) {
//         final book = results[index];
//         return BookCard(
//           book: book,
//           buttonText: "Add to Cart",
//           buttonColor: AppColors.success,
//           onAction: () {
//             onAddToCart(book);
//             close(context, null); // Close search after adding
//           },
//         );
//       },
//     );
//   }
// }
