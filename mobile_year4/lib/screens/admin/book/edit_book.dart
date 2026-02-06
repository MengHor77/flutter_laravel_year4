import 'dart:convert';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditBook extends StatefulWidget {
  final Map book;
  final VoidCallback onRefresh;
  const EditBook({super.key, required this.book, required this.onRefresh});

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _authorController;
  String? _selectedCategoryId;
  List _categories = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.book['name']);
    _authorController = TextEditingController(text: widget.book['author']);
    _selectedCategoryId = widget.book['category_id'].toString();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse(ApiConfig.categories));
    if (response.statusCode == 200) {
      setState(() => _categories = jsonDecode(response.body));
    }
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final response = await http.put(
      Uri.parse("${ApiConfig.books}/${widget.book['id']}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": _nameController.text,
        "author": _authorController.text,
        "category_id": _selectedCategoryId,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Book updated!"),
          backgroundColor: Colors.green,
        ),
      );
      widget.onRefresh();
      Navigator.pop(context);
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Book"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Book Name"),
            ),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: "Author"),
            ),
            DropdownButtonFormField(
              value: _selectedCategoryId,
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
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _update,
          child: _isSaving
              ? const CircularProgressIndicator()
              : const Text("Update"),
        ),
      ],
    );
  }
}
