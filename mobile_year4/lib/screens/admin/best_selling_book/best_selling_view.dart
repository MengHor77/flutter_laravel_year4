import 'dart:convert';
import '../../../colors.dart';
import 'edit_best_selling.dart';
import '../../../api_config.dart';
import 'create_best_selling.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BestSellingView extends StatefulWidget {
  final VoidCallback openDrawer;
  const BestSellingView({super.key, required this.openDrawer});

  @override
  State<BestSellingView> createState() => _AdminBestSellingViewState();
}

class _AdminBestSellingViewState extends State<BestSellingView> {
  List<dynamic> _bestSellers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBestSellers();
  }

  Future<void> _fetchBestSellers() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.bestSelling),
        headers: ApiConfig.getHeaders(),
      );
      if (response.statusCode == 200) {
        setState(() => _bestSellers = jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteBestSeller(int id) async {
    final response = await http.delete(
      Uri.parse("${ApiConfig.bestSelling}/$id"),
      headers: ApiConfig.getHeaders(),
    );
    if (response.statusCode == 200) {
      _fetchBestSellers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from Best Sellers")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Manage Best Selling"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateBestSelling()),
        ).then((_) => _fetchBestSellers()),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _bestSellers.length,
              itemBuilder: (context, index) {
                final item = _bestSellers[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.accent,
                      child: Icon(Icons.star, color: Colors.white),
                    ),
                    title: Text(item['book']['name']),
                    subtitle: Text("Price: \$${item['book']['price']}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditBestSelling(item: item),
                            ),
                          ).then((_) => _fetchBestSellers()),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.danger,
                          ),
                          onPressed: () => _deleteBestSeller(item['id']),
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
