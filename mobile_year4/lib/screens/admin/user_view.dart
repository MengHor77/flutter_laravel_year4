import 'package:flutter/material.dart';

class UserView extends StatelessWidget {
  final VoidCallback openDrawer;
  const UserView({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: openDrawer,
        ),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text("User Customer #$index"),
            subtitle: Text("user$index@gmail.com"),
            trailing: const Icon(Icons.more_vert),
          );
        },
      ),
    );
  }
}
