import '../../../colors.dart';
import 'edit_special_offer.dart';
import 'package:flutter/material.dart';

class OfferSearchDelegate extends SearchDelegate {
  final List offers;
  final VoidCallback onRefresh;

  OfferSearchDelegate({required this.offers, required this.onRefresh});

  // Action buttons (Clear text)
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  // Leading icon (Back button)
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  // Results shown when user hits "Search"
  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  // Suggestions shown while typing
  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = offers.where((offer) {
      final title = offer['title'].toString().toLowerCase();
      final bookName = (offer['book']?['name'] ?? '').toString().toLowerCase();
      final discount = offer['discount_percentage'].toString();
      final search = query.toLowerCase();

      return title.contains(search) || 
             bookName.contains(search) || 
             discount.contains(search);
    }).toList();

    if (results.isEmpty) {
      return const Center(child: Text("No offers match your search."));
    }

    return ListView.builder(
      itemCount: results.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final offer = results[index];
        final book = offer['book'];

        return Card(
          color: AppColors.cardBg,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.local_offer, color: AppColors.warning),
            title: Text(offer['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              "${offer['discount_percentage']}% Off on ${book?['name'] ?? 'Book'}\nNow: \$${offer['offer_price']}",
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            onTap: () {
              // Open edit dialog directly from search results
              showDialog(
                context: context,
                builder: (context) => EditSpecialOffer(
                  offer: offer,
                  onRefresh: onRefresh,
                ),
              ).then((_) => close(context, null)); 
            },
          ),
        );
      },
    );
  }
}