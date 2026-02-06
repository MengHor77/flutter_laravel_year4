import 'dart:convert';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../colors.dart'; // 1. Import your color config

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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Category updated successfully!"),
              backgroundColor: AppColors.success, // Use Success (Green)
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
        SnackBar(
          content: Text(msg), 
          backgroundColor: AppColors.danger // Use Danger (Red)
        ),
      );
    }
  }

  // Helper for consistent TextField styling
  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.accent), // Blue accent line
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBg, // White
      title: const Text(
        "Edit Category",
        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController, 
            decoration: _inputStyle("Category Name"),
            cursorColor: AppColors.accent,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descController, 
            decoration: _inputStyle("Description"),
            cursorColor: AppColors.accent,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text(
            "Cancel", 
            style: TextStyle(color: AppColors.textSecondary)
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent, // Blue button
            foregroundColor: AppColors.textOnDark, // White text
          ),
          onPressed: _isSaving ? null : _update,
          child: _isSaving 
            ? const SizedBox(
                width: 20, 
                height: 20, 
                child: CircularProgressIndicator(
                  strokeWidth: 2, 
                  color: AppColors.textOnDark,
                ),
              ) 
            : const Text("Update"),
        ),
      ],
    );
  }
}