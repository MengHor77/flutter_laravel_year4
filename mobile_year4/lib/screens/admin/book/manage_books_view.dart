import 'package:flutter/material.dart';

class ManageBooksView extends StatelessWidget {
  final VoidCallback openDrawer;

  const ManageBooksView({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Light background to match the dashboard
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Manage Books"),
        // CHANGED: Match the BestSellingView blue
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: openDrawer, // Triggers the parent sidebar
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 5, // Replace with dynamic data from Laravel later
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.book, color: Colors.blue),
              title: Text(
                "Book Title #$index",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Author Name"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () {
                      // Logic for editing
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Logic for deleting
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to add a new book
        },
        // CHANGED: Match the blue theme
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
