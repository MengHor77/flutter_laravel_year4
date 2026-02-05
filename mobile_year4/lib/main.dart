import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/providers/book_provider.dart';
import 'package:mobile_year4/screens/login/login_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => BookProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}
