import 'dart:convert';
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
  String? _selectedCategoryId;
  List _categories = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse(ApiConfig.categories));
    if (response.statusCode == 200) {
      setState(() => _categories = jsonDecode(response.body));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null)
      return;
    setState(() => _isSaving = true);

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.books),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _nameController.text,
          "author": _authorController.text,
          "category_id": _selectedCategoryId,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Book added successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        widget.onRefresh();
        Navigator.pop(context);
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add New Book"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Book Name"),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: "Author"),
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),
            DropdownButtonFormField(
              hint: const Text("Select Category"),
              items: _categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c['id'].toString(),
                      child: Text(c['name']),
                    ),
                  )
                  .toList(),
              onChanged: (val) =>
                  setState(() => _selectedCategoryId = val as String?),
            ),
          ],
        ),
      ),
      actions: [
        if (_isSaving) const CircularProgressIndicator(),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: const Text("Save"),
        ),
      ],
    );
  }
}
