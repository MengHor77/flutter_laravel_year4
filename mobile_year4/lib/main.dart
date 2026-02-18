import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/providers/user_provider.dart';
import 'package:mobile_year4/providers/book_provider.dart';
import 'package:mobile_year4/providers/sale_provider.dart';
import 'package:mobile_year4/screens/auth/login_view.dart';
import 'package:mobile_year4/providers/theme_provider.dart';
import 'package:mobile_year4/providers/free_book_pdf_provider.dart';
import 'package:mobile_year4/providers/special_offers_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BookProvider()..fetchSavedOrders(),
        ),
        ChangeNotifierProvider(create: (_) => SaleProvider()),
        ChangeNotifierProvider(create: (_) => SpecialOffersProvider()),
        ChangeNotifierProvider(create: (_) => FreeBookPdfProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
      home: const LoginView(),
    );
  }
}
