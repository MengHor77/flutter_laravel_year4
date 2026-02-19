import '../../../colors.dart';
import 'package:flutter/material.dart';

class OrderSearchDelegate extends SearchDelegate {
  final List orders;
  final String Function(String?) getImageUrl;

  OrderSearchDelegate({required this.orders, required this.getImageUrl});

  @override
  String get searchFieldLabel => "Search Book or Customer...";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults();

  Widget _buildSearchResults() {
    // Filter by Book Name or User Name
    final results = orders.where((order) {
      final bookName = (order['book']?['name'] ?? "").toString().toLowerCase();
      final userName = (order['user']?['name'] ?? "").toString().toLowerCase();
      final input = query.toLowerCase();
      return bookName.contains(input) || userName.contains(input);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No matching orders found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final order = results[index];
        final book = order['book'];
        final user = order['user'];
        double price = double.tryParse(order['price'].toString()) ?? 0.0;
        int qty = int.tryParse(order['quantity'].toString()) ?? 1;
        double total = price * qty;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                getImageUrl(book?['image']),
                width: 50,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, e, s) => const Icon(Icons.book),
              ),
            ),
            title: Text(
              book?['name'] ?? "Deleted Book",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Customer: ${user?['name'] ?? 'Guest'}"),
                Text(
                  "Total: \$${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Optional: You can navigate to a Detail page here
            },
          ),
        );
      },
    );
  }
}
