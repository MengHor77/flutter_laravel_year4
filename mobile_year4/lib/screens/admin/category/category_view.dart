import 'dart:convert';
import 'edit_category.dart';
import 'create_category.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../colors.dart'; // 1. Import your color config

class CategoryView extends StatefulWidget {
  final VoidCallback openDrawer;
  const CategoryView({super.key, required this.openDrawer});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.categories));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            categories = json.decode(response.body);
            isLoading = false;
          });
        }
      }
    } catch (e) {
      _showSnackBar("Connection Error", AppColors.danger); // Use Danger (Red)
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final response = await http.delete(Uri.parse("${ApiConfig.categories}/$id"));
      if (response.statusCode == 200) {
        _showSnackBar("Deleted successfully", AppColors.success); // Use Success (Green)
        fetchCategories();
      }
    } catch (e) {
      _showSnackBar("Delete failed", AppColors.danger);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Match dashboard background
      appBar: AppBar(
        title: const Text("Categories"),
        backgroundColor: AppColors.primary, // BlueGrey[900]
        foregroundColor: AppColors.textOnDark,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: widget.openDrawer),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : RefreshIndicator(
              onRefresh: fetchCategories,
              color: AppColors.accent,
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Card(
                    color: AppColors.cardBg, // White
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(
                        cat['name'],
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        cat['description'] ?? '',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: AppColors.warning), // Orange
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => EditCategory(
                                category: cat,
                                onRefresh: fetchCategories,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: AppColors.danger), // Red
                            onPressed: () => _confirmDelete(cat['id'], cat['name']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent, // Blue
        child: const Icon(Icons.add, color: AppColors.textOnDark),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => CreateCategory(onRefresh: fetchCategories),
        ),
      ),
    );
  }

  void _confirmDelete(int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Category?"),
        content: Text("Are you sure you want to delete '$name'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              deleteCategory(id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: AppColors.textOnDark)),
          ),
        ],
      ),
    );
  }
}