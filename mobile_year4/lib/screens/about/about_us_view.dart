import 'package:flutter/material.dart';
import 'package:mobile_year4/widgets/menu_sidebar.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us'), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      drawer: const AppSidebar(currentRoute: 'About Us'),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            'We are a leading bookstore providing high-quality educational resources.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}