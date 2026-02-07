import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateSpecialOffer extends StatefulWidget {
  final VoidCallback onRefresh;
  const CreateSpecialOffer({super.key, required this.onRefresh});

  @override
  State<CreateSpecialOffer> createState() => _CreateSpecialOfferState();
}

class _CreateSpecialOfferState extends State<CreateSpecialOffer> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _discountController = TextEditingController();
  String? _selectedBookId;
  List _books = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedBookId == null) {
      return;
    }
    
    setState(() => _isSaving = true);

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.specialOffers),
        body: {
          'book_id': _selectedBookId,
          'title': _titleController.text,
          'discount_percentage': _discountController.text,
        },
      );

      // Guarding the async gap: Check if the widget is still in the tree
      if (!mounted) return;

      if (response.statusCode == 201) {
        widget.onRefresh();
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Save error: $e");
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBg,
      title: const Text(
        "Add Special Offer",
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.cardBg,
                decoration: const InputDecoration(labelText: "Select Book"),
                hint: const Text("Select Book"),
                items: _books.map((b) => DropdownMenuItem<String>(
                  value: b['id'].toString(),
                  child: Text(b['name']),
                )).toList(),
                onChanged: (val) => setState(() => _selectedBookId = val),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController, 
                decoration: const InputDecoration(labelText: "Offer Title"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _discountController,
                decoration: const InputDecoration(
                  labelText: "Discount %",
                  suffixText: "%",
                ),
                keyboardType: TextInputType.number,
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
          ),
          onPressed: _isSaving ? null : _save, 
          child: _isSaving 
            ? const SizedBox(
                width: 20, 
                height: 20, 
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ) 
            : const Text("Save"),
        ),
      ],
    );
  }
}