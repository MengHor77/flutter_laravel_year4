import 'dart:convert';
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
    final response = await http.get(Uri.parse(ApiConfig.books));
    if (response.statusCode == 200) {
      setState(() => _books = jsonDecode(response.body));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedBookId == null) return;
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

      if (response.statusCode == 201) {
        widget.onRefresh();
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Save error: $e");
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Special Offer"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              hint: const Text("Select Book"),
              items: _books.map((b) => DropdownMenuItem<String>(
                value: b['id'].toString(),
                child: Text(b['name']),
              )).toList(),
              onChanged: (val) => setState(() => _selectedBookId = val),
            ),
            TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: "Offer Title")),
            TextFormField(
              controller: _discountController,
              decoration: const InputDecoration(labelText: "Discount %"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(onPressed: _isSaving ? null : _save, child: const Text("Save")),
      ],
    );
  }
}