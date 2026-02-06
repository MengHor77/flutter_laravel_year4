import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  final VoidCallback openDrawer;
  const CategoryView({super.key, required this.openDrawer});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  // Static list for UI testing - Replace this with your API data later
  final List<Map<String, String>> categories = [
    {"name": "Programming", "description": "Books about coding and software"},
    {"name": "Fiction", "description": "Story books and novels"},
    {"name": "History", "description": "Historical events and biographies"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Manage Categories"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.category, color: Colors.white, size: 20),
              ),
              title: Text(
                categories[index]['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                categories[index]['description']!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange, size: 22),
                    onPressed: () => _showCategoryDialog(
                      context,
                      title: "Edit Category",
                      name: categories[index]['name'],
                      desc: categories[index]['description'],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 22),
                    onPressed: () => _confirmDelete(context, index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, title: "Add New Category"),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- UI HELPER METHODS ---

  void _showCategoryDialog(BuildContext context, {required String title, String? name, String? desc}) {
    final nameController = TextEditingController(text: name);
    final descController = TextEditingController(text: desc);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Category Name",
                hintText: "e.g. Science Fiction",
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                hintText: "Enter category details...",
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              debugPrint("Saving: ${nameController.text}");
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete '${categories[index]['name']}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("No")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Yes, Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}