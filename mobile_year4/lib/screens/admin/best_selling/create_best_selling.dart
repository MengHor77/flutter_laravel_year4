import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateBestSelling extends StatefulWidget {
  const CreateBestSelling({super.key});

  @override
  State<CreateBestSelling> createState() => _CreateBestSellingState();
}

class _CreateBestSellingState extends State<CreateBestSelling> {
  List<dynamic> _books = [];
  String? _selectedBookId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final response = await http.get(Uri.parse(ApiConfig.books), headers: ApiConfig.getHeaders());
    if (response.statusCode == 200) {
      setState(() => _books = jsonDecode(response.body));
    }
  }

  Future<void> _submit() async {
    if (_selectedBookId == null) return;
    setState(() => _isSubmitting = true);
    final response = await http.post(
      Uri.parse(ApiConfig.bestSelling),
      headers: ApiConfig.getHeaders(),
      body: jsonEncode({"book_id": _selectedBookId}),
    );
    if (response.statusCode == 201) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Book already in list!")));
    }
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Best Seller")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Select Book"),
              items: _books.map((b) => DropdownMenuItem(value: b['id'].toString(), child: Text(b['name']))).toList(),
              onChanged: (val) => setState(() => _selectedBookId = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white),
              child: _isSubmitting ? const CircularProgressIndicator() : const Text("SAVE RECORD"),
            )
          ],
        ),
      ),
    );
  }
}