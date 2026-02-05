import 'package:flutter/material.dart';
import 'package:mobile_year4/widgets/menu_sidebar.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us'), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      drawer: const AppSidebar(currentRoute: 'Contact Us'),
      body: const Center(child: Text('Contact Support: 012 345 678', style: TextStyle(fontSize: 20))),
    );
  }
}