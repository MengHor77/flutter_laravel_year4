import 'dart:io';
import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../models/book_model.dart';
import 'package:image_picker/image_picker.dart';

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
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.book.name);
    _authorController = TextEditingController(text: widget.book.author);
    _priceController = TextEditingController(text: widget.book.price);
    _fetchCategories();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.categories));
      if (response.statusCode == 200) {
        setState(() {
          _categories = jsonDecode(response.body);
          try {
            _selectedCategoryId = _categories.firstWhere((c) => c['name'] == widget.book.categoryName)['id'].toString();
          } catch (e) { _selectedCategoryId = null; }
        });
      }
    } catch (e) { debugPrint("Error: $e"); }
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) return;
    setState(() => _isSaving = true);

    try {
      // Laravel PUT with files works best as a POST request with _method field
      var request = http.MultipartRequest('POST', Uri.parse("${ApiConfig.books}/${widget.book.id}"));
      request.headers.addAll({"Accept": "application/json"});
      request.fields['_method'] = 'PUT'; // Laravel spoofing
      
      request.fields['name'] = _nameController.text;
      request.fields['author'] = _authorController.text;
      request.fields['price'] = _priceController.text;
      request.fields['category_id'] = _selectedCategoryId!;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      }

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        widget.onRefresh();
        if (mounted) Navigator.pop(context);
      }
    } catch (e) { debugPrint("Error: $e"); }
    finally { if (mounted) setState(() => _isSaving = false); }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Book"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100, width: 100,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: _imageFile != null 
                    ? Image.file(_imageFile!, fit: BoxFit.cover) 
                    : Image.network(widget.book.image ?? '', errorBuilder: (ctx, err, stack) => const Icon(Icons.add_a_photo)),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
              TextFormField(controller: _authorController, decoration: const InputDecoration(labelText: "Author")),
              TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: "Price")),
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                items: _categories.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['name']))).toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(onPressed: _isSaving ? null : _update, child: const Text("Update")),
      ],
    );
  }
}