import 'dart:convert';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditCategory extends StatefulWidget {
  final Map category;
  final VoidCallback onRefresh;
  const EditCategory({super.key, required this.category, required this.onRefresh});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category['name']);
    _descController = TextEditingController(text: widget.category['description']);
  }

  Future<void> _update() async {
    if (_nameController.text.isEmpty) return;
    setState(() => _isSaving = true);
    
    try {
      final response = await http.put(
        Uri.parse("${ApiConfig.categories}/${widget.category['id']}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _nameController.text,
          "description": _descController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Category updated successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        }
        widget.onRefresh();
        if (mounted) Navigator.pop(context);
      } else {
        _showError("Update failed: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Connection error: Server is unreachable");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Category"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Category Name")),
          TextField(controller: _descController, decoration: const InputDecoration(labelText: "Description")),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: _isSaving ? null : _update,
          child: _isSaving 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
            : const Text("Update"),
        ),
      ],
    );
  }
}