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
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
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
            // កំណត់ ID របស់ Category ដែលមានស្រាប់
            _selectedCategoryId = _categories
                .firstWhere((c) => c['name'] == widget.book.categoryName)['id']
                .toString();
          } catch (e) {
            _selectedCategoryId = null;
          }
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Future<void> _update() async {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${ApiConfig.books}/${widget.book.id}"),
      );
      request.headers.addAll({"Accept": "application/json"});
      request.fields['_method'] = 'PUT';

      request.fields['name'] = _nameController.text.trim();
      request.fields['author'] = _authorController.text.trim();
      request.fields['price'] = _priceController.text.trim();
      request.fields['category_id'] = _selectedCategoryId!;

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', _imageFile!.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        widget.onRefresh();
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ✅ ជំនួយការបង្កើត URL រូបភាពឱ្យបានត្រឹមត្រូវ
  String _getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return "${ApiConfig.storage}$path";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBg,
      title: const Text(
        "Edit Book",
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(color: AppColors.accent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: _imageFile != null
                        ? Image.file(_imageFile!, fit: BoxFit.cover)
                        : Image.network(
                            _getImageUrl(widget.book.image),
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => const Icon(
                              Icons.add_a_photo,
                              color: AppColors.accent,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: "Author"),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),

              // ✅ ដំណោះស្រាយសម្រាប់ Warning: ប្តូរពី value ទៅ initialValue
              DropdownButtonFormField<String>(
                initialValue: _selectedCategoryId,
                decoration: const InputDecoration(labelText: "Category"),
                items: _categories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c['id'].toString(),
                        child: Text(c['name']),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
                validator: (v) => v == null ? "Required" : null,
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
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnDark,
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
