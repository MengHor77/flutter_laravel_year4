import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  final VoidCallback openDrawer;
  const CategoryView({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Categories"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: openDrawer,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.category, color: Colors.blueGrey),
              title: Text("Category Name #$index"),
              trailing: const Icon(Icons.edit, size: 20),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
