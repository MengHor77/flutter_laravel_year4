import 'dart:convert';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateCategory extends StatefulWidget {
  final VoidCallback onRefresh;
  const CreateCategory({super.key, required this.onRefresh});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _isSaving = false;

  Future<void> _save() async {
    if (_nameController.text.isEmpty) return;
    setState(() => _isSaving = true);

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.categories),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _nameController.text,
          "description": _descController.text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Category added successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        }
        widget.onRefresh();
        if (mounted) Navigator.pop(context);
      } else {
        // Show error message from server
        final error = jsonDecode(response.body);
        _showError(error['message'] ?? "Failed to add category");
      }
    } catch (e) {
      _showError("Connection error: Could not reach server");
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
      title: const Text("Add New Category"),
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
          onPressed: _isSaving ? null : _save,
          child: _isSaving 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
            : const Text("Save"),
        ),
      ],
    );
  }
}