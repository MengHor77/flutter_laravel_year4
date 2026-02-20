import 'dart:convert';
import '../../../colors.dart';
import 'edit_special_offer.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OfferSearchDelegate extends SearchDelegate {
  final List offers;
  final VoidCallback onRefresh;

  OfferSearchDelegate({required this.offers, required this.onRefresh});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: AppColors.textHint),
        border: InputBorder.none,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.accent,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: AppColors.textOnDark, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: AppColors.textOnDark),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.textOnDark),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  // --- NEW: Delete Logic ---
  Future<void> _deleteOffer(BuildContext context, dynamic offer) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to remove this offer?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final response = await http.delete(
          Uri.parse("${ApiConfig.specialOffers}/${offer['id']}"),
        );
        if (response.statusCode == 200 || response.statusCode == 204) {
          onRefresh();
          close(context, null); // Close search after deletion
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Offer deleted"),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        debugPrint("Delete error: $e");
      }
    }
  }

  Widget _buildSearchResults(BuildContext context) {
    final results = offers.where((offer) {
      final title = offer['title'].toString().toLowerCase();
      final bookName = (offer['book']?['name'] ?? '').toString().toLowerCase();
      final discount = offer['discount_percentage'].toString();
      final search = query.toLowerCase();
      return title.contains(search) ||
          bookName.contains(search) ||
          discount.contains(search.replaceAll('%', ''));
    }).toList();

    if (results.isEmpty) {
      return Container(
        color: AppColors.background,
        child: const Center(
          child: Text(
            "No offers match your search.",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      color: AppColors.background,
      child: ListView.builder(
        itemCount: results.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final offer = results[index];
          return Card(
            color: AppColors.cardBg,
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.local_offer, color: AppColors.warning),
              title: Text(
                offer['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                "${offer['discount_percentage']}% Off\nNow: \$${offer['offer_price']}",
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              // --- FIXED: Added Action Buttons Here ---
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.accent),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditSpecialOffer(
                          offer: offer,
                          onRefresh: onRefresh,
                        ),
                      ).then((_) => close(context, null));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.danger),
                    onPressed: () => _deleteOffer(context, offer),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
