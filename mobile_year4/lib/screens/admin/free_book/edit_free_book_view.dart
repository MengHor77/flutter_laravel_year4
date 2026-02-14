import '../../../colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FreeBookPdfProvider>(context);

    return AlertDialog(
      title: const Text("Edit Book Metadata"),
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
                    final success = await provider.updateFreeBook(
                      widget.book.id,
                      {
                        "name": nameController.text.trim(),
                        "author": authorController.text.trim(),
                        "category_id": widget
                            .book
                            .categoryId, // Matches the new Model field
                      },
                    );
                    if (success && mounted) Navigator.pop(context);
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
