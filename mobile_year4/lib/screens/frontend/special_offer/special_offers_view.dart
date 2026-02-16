import 'dart:async';  
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

   Future<void> _handleAddToCart(Map offerData) async {
    // 1. Check Login
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
      // 2. Perform logic
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
              // Close snackbar immediately
              messenger.hideCurrentSnackBar();

               if (bookProvider.onOrderSuccess != null) {
                bookProvider.onOrderSuccess!(2);  
              }
            },
          ),
        ),
      );

      // 4.  
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
    return Consumer<SpecialOffersProvider>(
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
            padding: const EdgeInsets.all(10),
            itemCount: provider.offers.length,
            itemBuilder: (context, index) {
              final offer = provider.offers[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.local_offer,
                        color: AppColors.danger,  
                        size: 40,
                      ),
                      title: Text(
                        offer['title'] ?? 'Special Offer',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Book: ${offer['book']['name']}\nDiscount: ${offer['discount_percentage']}%",
                      ),
                      trailing: Text(
                        "\$${offer['offer_price']}",
                        style: const TextStyle(
                          color:
                              AppColors.success,  
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _handleAddToCart(offer),
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text("Add to Cart"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppColors.accent,  
                            foregroundColor: Colors.white,
                          ),
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
    );
  }
}
