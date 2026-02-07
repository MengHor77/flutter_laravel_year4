import '../../../api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditSpecialOffer extends StatefulWidget {
  final Map offer;
  final VoidCallback onRefresh;

  const EditSpecialOffer({
    super.key,
    required this.offer,
    required this.onRefresh,
  });

  @override
  State<EditSpecialOffer> createState() => _EditSpecialOfferState();
}

class _EditSpecialOfferState extends State<EditSpecialOffer> {
  late TextEditingController _titleController;
  late TextEditingController _discountController;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _titleController = TextEditingController(text: widget.offer['title']);
    _discountController = TextEditingController(
      text: widget.offer['discount_percentage'].toString(),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    // Validate form before sending
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final response = await http.put(
        Uri.parse("${ApiConfig.specialOffers}/${widget.offer['id']}"),
        // Critical: Add headers so Laravel identifies the request correctly
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          'title': _titleController.text,
          'discount_percentage': _discountController.text,
          'book_id': widget.offer['book_id'].toString(),
        },
      );

      if (response.statusCode == 200) {
        widget.onRefresh(); // Refresh the list in the main view
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Offer updated successfully"),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        debugPrint("Server Error: ${response.body}");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to update: ${response.statusCode}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint("Update error: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Row(
        children: [
          Icon(Icons.edit, color: Colors.blue),
          SizedBox(width: 10),
          Text("Edit Special Offer"),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Offer Title",
                hintText: "e.g., Summer Sale",
                border: OutlineInputBorder(),
              ),
              validator: (val) => val!.isEmpty ? "Title is required" : null,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _discountController,
              decoration: const InputDecoration(
                labelText: "Discount %",
                hintText: "e.g., 20",
                border: OutlineInputBorder(),
                suffixText: "%",
              ),
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val!.isEmpty) return "Discount is required";
                final n = double.tryParse(val);
                if (n == null || n < 0 || n > 100) return "Enter 0-100";
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _update,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[900],
            foregroundColor: Colors.white,
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text("Update"),
        ),
      ],
    );
  }
}
