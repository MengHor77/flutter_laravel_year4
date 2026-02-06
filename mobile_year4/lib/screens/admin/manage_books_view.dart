import 'package:flutter/material.dart';

class ManageBooksView extends StatelessWidget {
  const ManageBooksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 5, // Replace with dynamic list from Laravel
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.book, color: Colors.blue),
              title: Text("Book Title #$index"),
              subtitle: const Text("Author Name"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logic to add a new book
        },
        backgroundColor: Colors.blueGrey[900],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}