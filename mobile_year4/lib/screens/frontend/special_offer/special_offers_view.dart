import 'dart:async';
import 'search_offer.dart'; 
import '../../../../colors.dart';
import '../../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/book_model.dart';
import '../../../providers/book_provider.dart';
import '../../../providers/special_offers_provider.dart';

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

  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return 'https://via.placeholder.com/150';
    if (path.startsWith('http')) return path;
    return "${ApiConfig.storage}${path.startsWith('/') ? path.substring(1) : path}";
  }

  Future<void> _handleAddToCart(Map offerData) async {
    if (ApiConfig.userToken == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Login first!"),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    Book bookToOrder = Book(
      id: offerData['book_id'].toString(),
      name: offerData['book']['name'],
      author: offerData['book']['author'] ?? 'Unknown',
      price: offerData['book']['price'].toString(),
      displayPrice: offerData['offer_price'].toString(),
      image: offerData['book']['image'],
      categoryName: 'Special Offer',
      isOnSale: true,
    );

    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();

    try {
      await bookProvider.addToCart(bookToOrder);
      if (!mounted) return;

      messenger.showSnackBar(
        SnackBar(
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          content: Text("${bookToOrder.name} added successfully!"),
          action: SnackBarAction(
            label: "VIEW",
            textColor: Colors.white,
            onPressed: () {
              messenger.hideCurrentSnackBar();
              if (bookProvider.onOrderSuccess != null) {
                bookProvider.onOrderSuccess!(2);
              }
            },
          ),
        ),
      );

      Timer(const Duration(seconds: 2), () {
        if (mounted) messenger.hideCurrentSnackBar();
      });
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Special Promotions",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          Consumer<SpecialOffersProvider>(
            builder: (context, provider, child) {
              return IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SearchOfferDelegate(
                      offers: provider.offers,
                      onAddToCart: _handleAddToCart,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<SpecialOffersProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          if (provider.offers.isEmpty) {
            return const Center(child: Text('No offers available right now.'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchOffers(),
            color: AppColors.accent,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.offers.length,
              itemBuilder: (context, index) {
                final offer = provider.offers[index];
                final String imageUrl = _getImageUrl(offer['book']['image']);

                return Container(
                  height: 155,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              bottomLeft: Radius.circular(18),
                            ),
                            child: Image.network(
                              imageUrl,
                              width: 110,
                              height: 155,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 110,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.danger,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "-${offer['discount_percentage']}%",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                offer['title']?.toUpperCase() ??
                                    'SPECIAL OFFER',
                                style: const TextStyle(
                                  color: AppColors.danger,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                offer['book']['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFF2D2D2D),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "\$${offer['book']['price']}",
                                        style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        "\$${offer['offer_price']}",
                                        style: const TextStyle(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Material(
                                    color: AppColors.success,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      onTap: () => _handleAddToCart(offer),
                                      borderRadius: BorderRadius.circular(12),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add_shopping_cart,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              "Add",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
