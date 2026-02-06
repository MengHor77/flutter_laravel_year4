import 'dart:convert';
import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../colors.dart'; // 1. Import your color config

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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Category added successfully!"),
              backgroundColor: AppColors.success, // 2. Use Success Color (Green)
            ),
          );
        }
        widget.onRefresh();
        if (mounted) Navigator.pop(context);
      } else {
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
        SnackBar(
          content: Text(msg), 
          backgroundColor: AppColors.danger // 3. Use Danger Color (Red)
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
        borderSide: BorderSide(color: AppColors.accent), // Blue line when typing
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBg, // White
      title: const Text(
        "Add New Category",
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
          child: const Text("Cancel", style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent, // Blue button
            foregroundColor: AppColors.textOnDark, // White text
          ),
          onPressed: _isSaving ? null : _save,
          child: _isSaving 
            ? const SizedBox(
                width: 20, 
                height: 20, 
                child: CircularProgressIndicator(
                  strokeWidth: 2, 
                  color: AppColors.textOnDark,
                ),
              ) 
            : const Text("Save"),
        ),
      ],
    );
  }
}