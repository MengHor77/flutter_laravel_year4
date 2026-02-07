import 'dart:convert';
import '../../../colors.dart';
import 'edit_special_offer.dart';
import '../../../api_config.dart';
import 'create_special_offer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SpecialOfferView extends StatefulWidget {
  final VoidCallback openDrawer;
  const SpecialOfferView({super.key, required this.openDrawer});

  @override
  State<SpecialOfferView> createState() => _SpecialOfferViewState();
}

class _SpecialOfferViewState extends State<SpecialOfferView> {
  List _offers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOffers();
  }

  Future<void> _fetchOffers() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(ApiConfig.specialOffers));
      if (response.statusCode == 200) {
        setState(() {
          _offers = jsonDecode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching offers: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteOffer(int id) async {
    try {
      final response = await http.delete(Uri.parse("${ApiConfig.specialOffers}/$id"));
      if (response.statusCode == 200) {
        _showSnackBar("Offer removed", Colors.red);
        _fetchOffers();
      }
    } catch (e) {
      debugPrint("Delete error: $e");
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Special Offers"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: widget.openDrawer),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchOffers),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => CreateSpecialOffer(onRefresh: _fetchOffers),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Active Promotions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _offers.isEmpty
                        ? const Center(child: Text("No active offers found"))
                        : RefreshIndicator(
                            onRefresh: _fetchOffers,
                            child: ListView.builder(
                              itemCount: _offers.length,
                              itemBuilder: (context, index) {
                                final offer = _offers[index];
                                final book = offer['book'];
                                return Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: const Icon(Icons.local_offer, color: Colors.orange),
                                    title: Text(offer['title']),
                                    subtitle: Text("${offer['discount_percentage']}% Off on ${book?['name'] ?? 'Book'}\nNow: \$${offer['offer_price']}"),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.blue),
                                          onPressed: () => showDialog(
                                            context: context,
                                            builder: (context) => EditSpecialOffer(offer: offer, onRefresh: _fetchOffers),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                                          onPressed: () => _deleteOffer(offer['id']),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}