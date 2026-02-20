import 'dart:async';
import '../../../../colors.dart';
import '../../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/book_model.dart';
import '../../../providers/book_provider.dart';
import '../../../providers/special_offers_provider.dart';
import '../../../../widgets/frontent/seach_book_global.dart';

class SpecialOffersView extends StatefulWidget {
  const SpecialOffersView({super.key});

  @override
  State<SpecialOffersView> createState() => _SpecialOffersViewState();
}

class _SpecialOffersViewState extends State<SpecialOffersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SpecialOffersProvider>().fetchOffers();
      }
    });
  }

  Book _mapOfferToBook(Map offerData) {
    return Book(
      id: offerData['book_id'].toString(),
      name: offerData['book']['name'] ?? 'Unknown',
      author: offerData['book']['author'] ?? 'Unknown Author',
      price: offerData['book']['price'].toString(),
      displayPrice: offerData['offer_price'].toString(),
      image: offerData['book']['image'],
      categoryName: 'Special Offer',
      isOnSale: true,
    );
  }

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return 'https://via.placeholder.com/150';
    if (path.startsWith('http')) return path;
    return "${ApiConfig.storage}${path.startsWith('/') ? path.substring(1) : path}";
  }

  @override
  Widget build(BuildContext context) {
    // Detect Dark Mode
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Consumer<SpecialOffersProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: isDark ? AppColors.accent : AppColors.accent,
            ),
          );
        }

        if (provider.offers.isEmpty) {
          return Center(
            child: Text(
              'No offers available right now.',
              style: TextStyle(color: AppColors.getTextSecondary(isDark)),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchOffers(),
          color: AppColors.accent,
          // Match RefreshIndicator background to view background
          backgroundColor: AppColors.getCardBg(isDark),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.offers.length,
            itemBuilder: (context, index) {
              final offer = provider.offers[index];
              final book = _mapOfferToBook(offer);
              final String imageUrl = _getImageUrl(offer['book']['image']);

              return Container(
                height: 155,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  // USE DYNAMIC CARD BG
                  color: AppColors.getCardBg(isDark),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: isDark
                      ? [] // Shadows usually look bad in dark mode, or use very subtle ones
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                  // ADD SUBTLE BORDER FOR DARK MODE
                  border: isDark
                      ? Border.all(color: AppColors.getBorder(isDark))
                      : null,
                ),
                child: Row(
                  children: [
                    _buildImage(imageUrl, offer['discount_percentage'], isDark),
                    _buildDetails(book, offer, isDark),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildImage(String url, dynamic discount, bool isDark) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            bottomLeft: Radius.circular(18),
          ),
          child: Image.network(
            url,
            width: 110,
            height: 155,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              width: 110,
              // DYNAMIC ERROR BG
              color: isDark ? Colors.grey[900] : Colors.grey[200],
              child: Icon(
                Icons.broken_image,
                color: AppColors.getTextSecondary(isDark),
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              // DYNAMIC DANGER COLOR
              color: AppColors.getDanger(isDark),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "-$discount%",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetails(Book book, Map offer, bool isDark) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              offer['title']?.toUpperCase() ?? 'PROMOTION',
              style: TextStyle(
                // DYNAMIC DANGER COLOR
                color: AppColors.getDanger(isDark),
                fontWeight: FontWeight.w800,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              book.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                // DYNAMIC PRIMARY TEXT
                color: AppColors.getTextPrimary(isDark),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\$${offer['book']['price']}",
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        // DYNAMIC SECONDARY TEXT
                        color: AppColors.getTextSecondary(isDark),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "\$${book.displayPrice}",
                      style: TextStyle(
                        // DYNAMIC SUCCESS COLOR
                        color: AppColors.getSuccess(isDark),
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // DYNAMIC SUCCESS COLOR
                      backgroundColor: AppColors.getSuccess(isDark),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => handleAddToCartGlobal(context, book),
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
