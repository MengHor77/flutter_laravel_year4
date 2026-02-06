import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditBestSelling extends StatefulWidget {
  final dynamic item;
  const EditBestSelling({super.key, required this.item});

  @override
  State<EditBestSelling> createState() => _EditBestSellingState();
}

class _EditBestSellingState extends State<EditBestSelling> {
  List<dynamic> _books = [];
  String? _selectedBookId;

  @override
  void initState() {
    super.initState();
    _selectedBookId = widget.item['book_id'].toString();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final response = await http.get(Uri.parse(ApiConfig.books), headers: ApiConfig.getHeaders());
    if (response.statusCode == 200) {
      setState(() => _books = jsonDecode(response.body));
    }
  }

  Future<void> _update() async {
    final response = await http.put(
      Uri.parse("${ApiConfig.bestSelling}/${widget.item['id']}"),
      headers: ApiConfig.getHeaders(),
      body: jsonEncode({"book_id": _selectedBookId}),
    );
    if (response.statusCode == 200) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Best Seller")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedBookId,
              decoration: const InputDecoration(labelText: "Change Book"),
              items: _books.map((b) => DropdownMenuItem(value: b['id'].toString(), child: Text(b['name']))).toList(),
              onChanged: (val) => setState(() => _selectedBookId = val),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _update, child: const Text("UPDATE")),
          ],
        ),
      ),
    );
  }
}