import 'sale_detail.dart';
import 'package:flutter/material.dart';
import 'package:mobile_year4/colors.dart';

class SaleSearchDelegate extends SearchDelegate {
  final List<dynamic> saleDetails;

  SaleSearchDelegate({required this.saleDetails});

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
    // Filter sales based on Book Name or User Name
    final results = saleDetails.where((sale) {
      final bookName = (sale['book']?['name'] ?? "").toString().toLowerCase();
      final userName = (sale['user']?['name'] ?? "").toString().toLowerCase();
      final input = query.toLowerCase();
      return bookName.contains(input) || userName.contains(input);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No matching transactions found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final sale = results[index];
        // Reuse your existing SaleDetailItem widget for consistency
        return SaleDetailItem(sale: sale);
      },
    );
  }
}
