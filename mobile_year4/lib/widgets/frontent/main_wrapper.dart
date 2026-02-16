import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/colors.dart';
import 'package:mobile_year4/providers/book_provider.dart'; 
import 'package:mobile_year4/widgets/frontent/menu_sidebar.dart';
import 'package:mobile_year4/screens/frontend/home/home_view.dart';
import 'package:mobile_year4/screens/frontend/book/book_view.dart';
import 'package:mobile_year4/screens/frontend/profile/profile.dart';
import 'package:mobile_year4/screens/frontend/about/about_us_view.dart';
import 'package:mobile_year4/screens/frontend/contact_us/contact_us_view.dart';
import 'package:mobile_year4/screens/frontend/order_list/order_list_view.dart';
import 'package:mobile_year4/screens/frontend/book_pdf_free/book_pdf_view.dart';
import 'package:mobile_year4/screens/frontend/special_offer/special_offers_view.dart';
import 'package:mobile_year4/screens/frontend/best_selling_view/best_selling_view.dart';



class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  // 1. All possible pages accessible via Drawer OR BottomBar
  final List<Widget> _pages = [
    const HomeView(),           // 0
    const BookView(),           // 1
    const OrderListView(),      // 2
    const BestSellingView(),    // 3
    const ProfileView(),        // 4
    const BookPdfView(),        // 5 (Drawer only)
    const SpecialOffersView(),  // 6 (Drawer only)
    const ContactUsView(),      // 7 (Drawer only)
    const AboutUsView(),        // 8 (Drawer only)
  ];

  // 2. Titles corresponding to the indices above
  final List<String> _titles = [
    'Home', 'Books', 'Order List', 'Best Selling', 'Profile', 
    'Book PDF Free', 'Special Offers', 'Contact Us', 'About Us'
  ];
  
  @override
  void initState() {
    super.initState();
    // Bridge the provider to the MainWrapper UI state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().onOrderSuccess = (index) {
        setState(() {
          _selectedIndex = index;
        });
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: AppColors.accent,
      ),
      drawer: AppSidebar(
        currentRoute: _titles[_selectedIndex],
        onIndexChanged: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Only show selection if index is 0-4 (the main menu items)
        currentIndex: _selectedIndex > 4 ? 0 : _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Books'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Order'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Best Seller'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}