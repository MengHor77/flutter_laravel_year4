import 'package:flutter/material.dart';
import 'package:mobile_year4/widgets/menu_sidebar.dart';

class SpecialOffersView extends StatelessWidget {
  const SpecialOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Special Offers'), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      drawer: const AppSidebar(currentRoute: 'Special Offers'),
      body: const Center(child: Text('Great Discounts Today!', style: TextStyle(fontSize: 20))),
    );
  }
}