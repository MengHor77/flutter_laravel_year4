import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../models/book_model.dart';

class EditBook extends StatefulWidget {
  final Book book;
  final VoidCallback onRefresh;

  const EditBook({super.key, required this.book, required this.onRefresh});

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _authorController;
  late TextEditingController _priceController;
  String? _selectedCategoryId;
  List _categories = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _nameController = TextEditingController(text: widget.book.name);
    _authorController = TextEditingController(text: widget.book.author);
    _priceController = TextEditingController(text: widget.book.price);
    _fetchCategories();
  }

  @override
  void dispose() {
    // IMPORTANT: Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.categories));
      if (response.statusCode == 200) {
        final List fetchedData = jsonDecode(response.body);
        setState(() {
          _categories = fetchedData;
          // Robust category matching
          try {
            _selectedCategoryId = _categories
                .firstWhere(
                  (c) =>
                      c['name'].toString().toLowerCase() ==
                      widget.book.categoryName.toLowerCase(),
                )['id']
                .toString();
          } catch (e) {
            _selectedCategoryId = null;
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final response = await http.put(
        Uri.parse("${ApiConfig.books}/${widget.book.id}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _nameController.text.trim(),
          "author": _authorController.text.trim(),
          "price": _priceController.text.trim(),
          "category_id": _selectedCategoryId,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Book updated successfully!"),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
          widget.onRefresh();
          Navigator.pop(context);
        }
      } else {
        throw Exception("Failed to update: ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error updating book. Please try again."),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      border: const OutlineInputBorder(), // Added border for cleaner UI
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        "Edit Book",
        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: _inputStyle("Book Name", Icons.book),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Required" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _authorController,
                  decoration: _inputStyle("Author", Icons.person),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Required" : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: _inputStyle("Price", Icons.attach_money),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? "Required" : null,
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: _inputStyle("Category", Icons.category),
                  initialValue: _selectedCategoryId,
                  items: _categories.map((c) {
                    return DropdownMenuItem<String>(
                      value: c['id'].toString(),
                      child: Text(c['name']),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCategoryId = val),
                  validator: (v) => v == null ? "Required" : null,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: _isSaving ? null : _update,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text("Update", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
