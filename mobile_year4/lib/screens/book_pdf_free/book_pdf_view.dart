import 'package:flutter/material.dart';
import 'package:mobile_year4/widgets/menu_sidebar.dart';

class BookPdfView extends StatelessWidget {
  const BookPdfView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book PDF Free'), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      drawer: const AppSidebar(currentRoute: 'Book PDF Free'),
      body: const Center(child: Text('Download Free PDF Books', style: TextStyle(fontSize: 20))),
    );
  }
}