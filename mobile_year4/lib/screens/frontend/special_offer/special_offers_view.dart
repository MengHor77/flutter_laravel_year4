import 'dart:convert';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../models/book_model.dart';
import '../../../providers/book_provider.dart';
import 'package:mobile_year4/widgets/frontent/menu_sidebar.dart';

class SpecialOffersView extends StatefulWidget {
  const SpecialOffersView({super.key});

  @override
  State<SpecialOffersView> createState() => _SpecialOffersViewState();
}

class _SpecialOffersViewState extends State<SpecialOffersView> {
  List _offers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOffers();
  }

  Future<void> _fetchOffers() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.specialOffers));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _offers = json.decode(response.body);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching offers: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAddToCart(Map offerData) async {
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

    await bookProvider.addToCart(bookToOrder);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${bookToOrder.name} added to cart!"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "OK",
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Special Offers'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: const AppSidebar(currentRoute: 'Special Offers'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchOffers,
              child: _offers.isEmpty
                  ? const Center(child: Text('No offers available right now.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: _offers.length,
                      itemBuilder: (context, index) {
                        final offer = _offers[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(
                                  Icons.local_offer,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                title: Text(
                                  offer['title'] ?? 'Special Offer',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  "Book: ${offer['book']['name']}\nDiscount: ${offer['discount_percentage']}%",
                                  style: const TextStyle(height: 1.5),
                                ),
                                trailing: Text(
                                  "\$${offer['offer_price']}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 8.0,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _handleAddToCart(offer),
                                    icon: const Icon(Icons.add_shopping_cart),
                                    label: const Text("Add to Cart"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
