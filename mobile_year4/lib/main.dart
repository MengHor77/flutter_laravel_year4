import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/providers/book_provider.dart';
import 'package:mobile_year4/screens/auth/login_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      // The ..fetchSavedOrders() ensures that as soon as the app starts,
      // it hits your Laravel API to get the saved items.
      create: (context) => BookProvider()..fetchSavedOrders(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Removed 'const' here because MaterialApp is dynamic
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const LoginView(),
    );
  }
}