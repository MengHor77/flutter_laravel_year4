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

  // Initialize the picker once
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Improved Image Picker Function
  Future<void> _pickImage() async {
    try {
      // Re-running 'flutter run' is required to link this native method
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
      // If you still see MissingPluginException here, you MUST stop and restart the app
      _showSnackBar("Error: Please restart your app to activate the gallery.", Colors.red);
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.categories));
      if (response.statusCode == 200) {
        setState(() => _categories = jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      _showSnackBar("Please select a category", Colors.orange);
      return;
    }

    setState(() => _isSaving = true);

    try {
      var request = http.MultipartRequest('POST', Uri.parse(ApiConfig.books));
      request.headers.addAll({"Accept": "application/json"});
      
      request.fields['name'] = _nameController.text.trim();
      request.fields['author'] = _authorController.text.trim();
      request.fields['price'] = _priceController.text.trim();
      request.fields['category_id'] = _selectedCategoryId!;

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSnackBar("Book added successfully!", Colors.green);
        widget.onRefresh();
        if (mounted) Navigator.pop(context);
      } else {
        _showSnackBar("Server Error: ${response.statusCode}", Colors.red);
      }
    } catch (e) {
      _showSnackBar("Connection error.", Colors.red);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      title: const Text("Add New Book", style: TextStyle(fontWeight: FontWeight.bold)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- IMAGE PICKER AREA ---
              GestureDetector(
                behavior: HitTestBehavior.opaque, 
                onTap: _pickImage,
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.withOpacity(0.2), width: 2),
                  ),
                  child: _imageFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud_upload_rounded, size: 45, color: Colors.blue),
                            const SizedBox(height: 10),
                            Text("Tap to open File Explorer", 
                                 style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                            const Text("PNG, JPG up to 5MB", style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(_imageFile!, fit: BoxFit.cover, width: double.infinity),
                        ),
                ),
              ),
              const SizedBox(height: 25),
              
              TextFormField(
                controller: _nameController, 
                decoration: _inputStyle("Book Name", Icons.book),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _authorController, 
                decoration: _inputStyle("Author", Icons.person),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _priceController, 
                keyboardType: TextInputType.number, 
                decoration: _inputStyle("Price", Icons.attach_money),
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                decoration: _inputStyle("Select Category", Icons.category),
                items: _categories.map((c) => DropdownMenuItem(
                  value: c['id'].toString(), 
                  child: Text(c['name'])
                )).toList(),
                onChanged: (val) => setState(() => _selectedCategoryId = val),
                validator: (v) => v == null ? "Required" : null,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.purple))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, 
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
          ),
          onPressed: _isSaving ? null : _save, 
          child: _isSaving 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
            : const Text("Save Book"),
        ),
      ],
    );
  }
}