import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateBook extends StatefulWidget {
  final VoidCallback onRefresh;
  const CreateBook({super.key, required this.onRefresh});

  @override
  State<CreateBook> createState() => _CreateBookState();
}

class _CreateBookState extends State<CreateBook> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _authorController = TextEditingController();
  final _priceController = TextEditingController();
  
  String? _selectedCategoryId;
  List _categories = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.categories));
      if (response.statusCode == 200) {
        setState(() {
          _categories = jsonDecode(response.body);
        });
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedCategoryId == null) {
      _showSnackBar("Please select a category", AppColors.warning);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.books),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json", // Added for Laravel compatibility
        },
        body: jsonEncode({
          "name": _nameController.text.trim(),
          "author": _authorController.text.trim(),
          "price": _priceController.text.trim(),
          "category_id": _selectedCategoryId,
        }),
      );

      // Laravel usually returns 201 for Created or 200 for OK
      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSnackBar("Book added successfully!", AppColors.success);
        widget.onRefresh();
        if (mounted) Navigator.pop(context);
      } else {
        // This helps you see why Laravel rejected it (e.g., validation errors)
        final errorData = jsonDecode(response.body);
        _showSnackBar("Error: ${errorData['message'] ?? response.statusCode}", AppColors.danger);
      }
    } catch (e) {
      _showSnackBar("Connection error. Check your server.", AppColors.danger);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating),
      );
    }
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBg,
      title: const Text("Add New Book", style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _inputStyle("Book Name", Icons.book_online),
                validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _authorController,
                decoration: _inputStyle("Author", Icons.person),
                validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: _inputStyle("Price", Icons.attach_money),
                validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: _inputStyle("Select Category", Icons.category),
                value: _selectedCategoryId, // Use 'value' instead of 'initialValue' for dynamic lists
                items: _categories.map((c) {
                  return DropdownMenuItem<String>(
                    value: c['id'].toString(),
                    child: Text(c['name']),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
                validator: (v) => v == null ? "Select a category" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white),
          onPressed: _isSaving ? null : _save,
          child: _isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text("Save"),
        ),
      ],
    );
  }
}