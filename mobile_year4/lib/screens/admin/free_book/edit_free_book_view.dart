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

  Future<void> _pickPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        newPdfFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FreeBookPdfProvider>(context);

    return AlertDialog(
      title: const Text("Edit Book"),
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
            const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                newPdfFile == null
                    ? "Update PDF (Optional)"
                    : "New PDF Selected",
              ),
              subtitle: Text(
                newPdfFile?.path.split('/').last ?? "No new file chosen",
              ),
              trailing: IconButton(
                icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                onPressed: _pickPdf,
              ),
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
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () async {
                  if (nameController.text.isNotEmpty) {
                    final success = await provider
                        .updateFreeBook(widget.book.id, {
                          "name": nameController.text.trim(),
                          "author": authorController.text.trim(),
                          "category_id": widget.book.categoryId,
                        }, pdfFile: newPdfFile);

                    if (!mounted) return;

                    if (success) {
                      Navigator.pop(context);
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
