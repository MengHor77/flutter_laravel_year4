import 'dart:convert';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        setState(() {
          _offers = json.decode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching offers: $e");
      setState(() => _isLoading = false);
    }
  }

  // --- Logic to Add to Order List ---
  Future<void> _addToCart(Map offer) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.orders), // api/orders
        headers: {
          "Accept": "application/json",
          // Adding Content-Type ensures Laravel parses the body correctly
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'book_id': offer['book_id'].toString(),
          'price': offer['offer_price'].toString(),
        },
      );

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${offer['book']['name']} added to cart!"),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'VIEW CART',
                textColor: Colors.white,
                onPressed: () {
                  // Navigate to your Order List page here if you want
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Add to cart error: $e");
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
                                  offer['title'],
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
                                    onPressed: () => _addToCart(offer),
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
