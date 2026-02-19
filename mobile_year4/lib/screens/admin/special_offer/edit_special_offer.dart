import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditSpecialOffer extends StatefulWidget {
  final Map offer;
  final VoidCallback onRefresh;

  const EditSpecialOffer({
    super.key,
    required this.offer,
    required this.onRefresh,
  });

  @override
  State<EditSpecialOffer> createState() => _EditSpecialOfferState();
}

class _EditSpecialOfferState extends State<EditSpecialOffer> {
  late TextEditingController _titleController;
  late TextEditingController _discountController;
  String? _selectedBookId;
  List _books = [];
  bool _isSaving = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _titleController = TextEditingController(text: widget.offer['title']);
    _discountController = TextEditingController(
      text: widget.offer['discount_percentage'].toString(),
    );
    // Set the initial book ID from the existing offer
    _selectedBookId = widget.offer['book_id'].toString();
    _fetchBooks();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.books));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() => _books = jsonDecode(response.body));
        }
      }
    } catch (e) {
      debugPrint("Fetch books error: $e");
    }
  }

  Future<void> _update() async {
    // Validate form and ensure a book is selected before sending
    if (!_formKey.currentState!.validate() || _selectedBookId == null) return;

    setState(() => _isSaving = true);

    try {
      final response = await http.put(
        Uri.parse("${ApiConfig.specialOffers}/${widget.offer['id']}"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'title': _titleController.text.trim(),
          'discount_percentage': _discountController.text.trim(),
          'book_id':
              _selectedBookId!, // Using the selected book ID from dropdown
        },
      );

      if (response.statusCode == 200) {
        widget.onRefresh();
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Offer updated successfully"),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        debugPrint("Server Error: ${response.body}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to update: ${response.statusCode}"),
              backgroundColor: AppColors.danger,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Update error: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text(
        "Edit Special Offer",
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Added: Dropdown to select/change the book for this offer
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.cardBg,
                value: _selectedBookId,
                decoration: const InputDecoration(
                  labelText: "Select Book",
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                ),
                items: _books
                    .map(
                      (b) => DropdownMenuItem<String>(
                        value: b['id'].toString(),
                        child: Text(
                          b['name'],
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedBookId = val),
                validator: (val) => val == null ? "Please select a book" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _titleController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: "Offer Title",
                  hintText: "e.g., Summer Sale",
                ),
                validator: (val) => val!.isEmpty ? "Title is required" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _discountController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  labelText: "Discount %",
                  hintText: "e.g., 20",
                  suffixText: "%",
                  suffixStyle: TextStyle(color: AppColors.accent),
                ),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val!.isEmpty) return "Discount is required";
                  final n = double.tryParse(val);
                  if (n == null || n < 0 || n > 100) return "Enter 0-100";
                  return null;
                },
              ),
            ],
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
            foregroundColor: AppColors.textOnDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
              : const Text("Update"),
        ),
      ],
    );
  }
}
