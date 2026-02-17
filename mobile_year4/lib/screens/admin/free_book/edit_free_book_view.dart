import 'dart:io';
import '../../../colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../models/free_book_pdf_model.dart';
import '../../../providers/free_book_pdf_provider.dart';

class EditFreeBookView extends StatefulWidget {
  final FreeBookPdf book;
  const EditFreeBookView({super.key, required this.book});

  @override
  State<EditFreeBookView> createState() => _EditFreeBookViewState();
}

class _EditFreeBookViewState extends State<EditFreeBookView> {
  late TextEditingController nameController;
  late TextEditingController authorController;
  File? newPdfFile;
  File? newImageFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.book.name);
    authorController = TextEditingController(text: widget.book.author);
  }

  @override
  void dispose() {
    nameController.dispose();
    authorController.dispose();
    super.dispose();
  }

  Future<void> _pickFile({required bool isPdf}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: isPdf ? FileType.custom : FileType.image,
      allowedExtensions: isPdf ? ['pdf'] : null,
    );
    if (result != null) {
      setState(() {
        if (isPdf) {
          newPdfFile = File(result.files.single.path!);
        } else {
          newImageFile = File(result.files.single.path!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FreeBookPdfProvider>(context);

    return AlertDialog(
      title: const Text("Edit Free Book"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Book Name"),
            ),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: "Author"),
            ),
            const SizedBox(height: 15),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.image, color: Colors.blue),
              title: Text(
                newImageFile == null
                    ? "Change Image (Optional)"
                    : "New Image Selected",
              ),
              subtitle: Text(
                newImageFile?.path.split('/').last ?? "Using current image",
              ),
              onTap: () => _pickFile(isPdf: false),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: Text(
                newPdfFile == null
                    ? "Update PDF (Optional)"
                    : "New PDF Selected",
              ),
              subtitle: Text(
                newPdfFile?.path.split('/').last ?? "Using current file",
              ),
              onTap: () => _pickFile(isPdf: true),
            ),
          ],
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
        provider.isSyncing
            ? const SizedBox(
                width: 40,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () async {
                  if (nameController.text.isNotEmpty) {
                    final Map<String, String> data = {
                      "name": nameController.text.trim(),
                      "author": authorController.text.trim(),
                      "category_id": widget.book.categoryId.toString(),
                    };

                    // ✅ Fix: បញ្ជូន Arguments ទៅតាមអ្វីដែល Provider ត្រូវការ
                    final success = await provider.updateFreeBook(
                      widget.book.id,
                      data,
                      pdfFile:
                          newPdfFile, // ត្រូវប្រាកដថាឈ្មោះ parameter ក្នុង provider ដូចគ្នា
                      imageFile: newImageFile,
                    );

                    if (!mounted) return;
                    if (success) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                child: const Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ],
    );
  }
}
