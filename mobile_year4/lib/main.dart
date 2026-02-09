import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/providers/book_provider.dart';
import 'package:mobile_year4/providers/sale_provider.dart';
import 'package:mobile_year4/screens/auth/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BookProvider()..fetchSavedOrders(),
        ),
        ChangeNotifierProvider(create: (_) => SaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      // Ensure LoginView is the starting point
      home: const LoginView(),
    );
  }
}
