import 'dart:io';
import 'dart:convert';
import '../../../colors.dart';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

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
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // ✅ បញ្ឈប់ការប្រើ Controller ដើម្បីការពារ Memory Leak
  @override
  void dispose() {
    _nameController.dispose();
    _authorController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
      if (mounted) {
        _showSnackBar(
          "Error: Please restart your app to activate the gallery.",
          AppColors.danger,
        );
      }
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.categories));
      if (response.statusCode == 200 && mounted) {
        setState(() => _categories = jsonDecode(response.body));
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
      var request = http.MultipartRequest('POST', Uri.parse(ApiConfig.books));
      request.headers.addAll({"Accept": "application/json"});

      request.fields['name'] = _nameController.text.trim();
      request.fields['author'] = _authorController.text.trim();
      request.fields['price'] = _priceController.text.trim().replaceAll(RegExp(r'[^0-9.]'), '');
      request.fields['category_id'] = _selectedCategoryId!;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // ✅ ឆែក mounted មុនពេលប្រើ BuildContext (Navigator ឬ SnackBar)
      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSnackBar("Book added successfully!", AppColors.success);
        widget.onRefresh();
        Navigator.pop(context);
      } else {
        _showSnackBar("Error: ${response.statusCode}", AppColors.danger);
      }
    } catch (e) {
      if (mounted) _showSnackBar("Connection error.", AppColors.danger);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxDialogHeight = MediaQuery.of(context).size.height * 0.7;

    return AlertDialog(
      backgroundColor: AppColors.cardBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Add New Book", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxDialogHeight),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2), width: 1.5),
                      ),
                      child: _imageFile == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 40, color: AppColors.accent),
                                SizedBox(height: 8),
                                Text("Upload Cover", style: TextStyle(fontSize: 14, color: AppColors.accent)),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(13),
                              child: Image.file(_imageFile!, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: _inputStyle("Book Name", Icons.book),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _authorController,
                    decoration: _inputStyle("Author", Icons.person),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: _inputStyle("Price", Icons.attach_money),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  const SizedBox(height: 12),
                  // ✅ ដំណោះស្រាយ Deprecated: ប្តូរពី 'value' ទៅ 'initialValue'
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _selectedCategoryId, 
                    decoration: _inputStyle("Category", Icons.category),
                    items: _categories.map((c) => DropdownMenuItem<String>(
                      value: c['id'].toString(),
                      child: Text(c['name'], overflow: TextOverflow.ellipsis),
                    )).toList(),
                    onChanged: (val) => setState(() => _selectedCategoryId = val),
                    validator: (v) => v == null ? "Required" : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textOnDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColors.textOnDark, strokeWidth: 2))
              : const Text("Save"),
        ),
      ],
    );
  }
}