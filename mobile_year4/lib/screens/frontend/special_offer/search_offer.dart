// import '../../../../colors.dart';
// import '../../../../api_config.dart';
// import 'package:flutter/material.dart';

// class SearchOfferDelegate extends SearchDelegate {
//   final List offers;
//   final Function(Map) onAddToCart;

//   SearchOfferDelegate({required this.offers, required this.onAddToCart});

//   String _getImageUrl(String? path) {
//     if (path == null || path.isEmpty) return 'https://via.placeholder.com/150';
//     if (path.startsWith('http')) return path;
//     return "${ApiConfig.storage}${path.startsWith('/') ? path.substring(1) : path}";
//   }

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
//     final results = offers.where((offer) {
//       final title = offer['title'].toString().toLowerCase();
//       final bookName = (offer['book']?['name'] ?? '').toString().toLowerCase();
//       final discount = offer['discount_percentage'].toString();
//       final search = query.toLowerCase();

//       return title.contains(search) ||
//           bookName.contains(search) ||
//           discount.contains(search);
//     }).toList();

//     if (results.isEmpty) {
//       return const Center(child: Text("No offers found."));
//     }

//     return ListView.builder(
//       itemCount: results.length,
//       padding: const EdgeInsets.all(16),
//       itemBuilder: (context, index) {
//         final offer = results[index];
//         final book = offer['book'];
//         final String imageUrl = _getImageUrl(book['image']);

//         return Card(
//           elevation: 2,
//           margin: const EdgeInsets.only(bottom: 12),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: ListTile(
//             leading: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 imageUrl,
//                 width: 50,
//                 height: 70,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             title: Text(
//               offer['title'],
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text("${book['name']}\nNow: \$${offer['offer_price']}"),
//             isThreeLine: true,
//             trailing: IconButton(
//               icon: const Icon(
//                 Icons.add_shopping_cart,
//                 color: AppColors.success,
//               ),
//               onPressed: () {
//                 onAddToCart(offer);
//                 close(context, null);
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
