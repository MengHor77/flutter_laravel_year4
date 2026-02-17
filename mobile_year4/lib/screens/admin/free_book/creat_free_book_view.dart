import 'dart:io';
import '../../../colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../providers/free_book_pdf_provider.dart';

class CreateFreeBookView extends StatefulWidget {
  const CreateFreeBookView({super.key});

  @override
  State<CreateFreeBookView> createState() => _CreateFreeBookViewState();
}

class _CreateFreeBookViewState extends State<CreateFreeBookView> {
  final nameController = TextEditingController();
  final authorController = TextEditingController();

  File? selectedImage;
  File? selectedPdf;
  String? selectedCategoryId;

  Future<void> _pickFile({required bool isPdf}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: isPdf ? FileType.custom : FileType.image,
        allowedExtensions: isPdf ? ['pdf'] : null,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          if (isPdf) {
            selectedPdf = File(result.files.single.path!);
          } else {
            selectedImage = File(result.files.single.path!);
          }
        });
      }
    } catch (e) {
      debugPrint("File picking error: $e");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FreeBookPdfProvider>(context);

    final categoryItems = provider.categories.map((cat) {
      return DropdownMenuItem<String>(
        value: cat['id'].toString(),
        child: Text(cat['name']),
      );
    }).toList();

    return AlertDialog(
      title: const Text("Add New Free Book"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedImage != null)
              Container(
                height: 100,
                width: 80,
                // ✅ Fix: class 'EdgeInsets' doesn't have a constant constructor 'bottom'
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: FileImage(selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Book Name"),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: "Author"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              // ✅ Fix: initialValue instead of value (deprecated) if using newer Flutter
              value: selectedCategoryId,
              decoration: const InputDecoration(labelText: "Select Category"),
              hint: const Text("Choose a category"),
              items: categoryItems,
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
            ),
            const SizedBox(height: 20),
            _fileTile(
              icon: Icons.image,
              title: selectedImage == null ? "Select Image" : "Image Selected",
              onTap: () => _pickFile(isPdf: false),
              color: selectedImage == null ? Colors.grey : Colors.blue,
              subtitle: selectedImage?.path.split('/').last,
            ),
            _fileTile(
              icon: Icons.picture_as_pdf,
              title: selectedPdf == null ? "Select PDF" : "PDF Selected",
              onTap: () => _pickFile(isPdf: true),
              color: selectedPdf == null ? Colors.grey : Colors.red,
              subtitle: selectedPdf?.path.split('/').last,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: provider.isSyncing ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        provider.isSyncing
            ? const SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () async {
                  if (nameController.text.isEmpty ||
                      selectedCategoryId == null ||
                      selectedImage == null ||
                      selectedPdf == null) {
                    _showError("All fields are required");
                    return;
                  }

                  final Map<String, String> fields = {
                    "name": nameController.text.trim(),
                    "author": authorController.text.trim(),
                    "category_id": selectedCategoryId!,
                  };

                  // ✅ Fix: បញ្ជូន positional arguments ឱ្យគ្រប់ (fields, image, pdf)
                  // ប្រសិនបើ Provider របស់អ្នកប្រើ Named parameters ត្រូវសរសេរឱ្យត្រូវឈ្មោះ
                  final success = await provider.addFreeBook(
                    fields,
                    selectedImage!, // Argument ទី ២
                    selectedPdf!, // Argument ទី ៣
                  );

                  if (!mounted) return;
                  if (success) Navigator.of(context).pop();
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ],
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _fileTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
    String? subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: const Icon(Icons.attach_file, size: 18),
      onTap: onTap,
    );
  }
}
