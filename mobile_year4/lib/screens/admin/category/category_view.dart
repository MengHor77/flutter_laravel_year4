import 'dart:convert';
import 'edit_category.dart';
import 'create_category.dart';
import '../../../colors.dart';
import 'Search_category.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    if (!mounted) return;
    setState(() => isLoading = true);
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
      if (mounted) {
        setState(() => isLoading = false);
        _showSnackBar("Connection Error", AppColors.danger);
      }
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("${ApiConfig.categories}/$id"),
      );
      if (response.statusCode == 200) {
        _showSnackBar("Deleted successfully", AppColors.success);
        fetchCategories();
      }
    } catch (e) {
      _showSnackBar("Delete failed", AppColors.danger);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Categories"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: "Search",
            onPressed: () {
              showSearch(
                context: context,
                delegate: CategorySearchDelegate(
                  categories: categories,
                  fetchCategories: fetchCategories,
                  confirmDelete: _confirmDelete,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh Categories",
            onPressed: fetchCategories,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: "Create Category",
            onPressed: () => showDialog(
              context: context,
              builder: (context) => CreateCategory(onRefresh: fetchCategories),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            )
          : RefreshIndicator(
              onRefresh: fetchCategories,
              color: AppColors.accent,
              child: categories.isEmpty
                  ? const Center(child: Text("No categories found"))
                  : ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return Card(
                          color: AppColors.cardBg,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey.shade200),
                          ),
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
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppColors.warning,
                                  ),
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => EditCategory(
                                      category: cat,
                                      onRefresh: fetchCategories,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColors.danger,
                                  ),
                                  onPressed: () =>
                                      _confirmDelete(cat['id'], cat['name']),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
            child: const Text(
              "Cancel",
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              deleteCategory(id);
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: AppColors.textOnDark),
            ),
          ),
        ],
      ),
    );
  }
}
