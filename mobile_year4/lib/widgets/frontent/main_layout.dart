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

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // 1. Pages List: Profile (6) is after Special Offers (5)
  final List<Widget> _pages = [
    const HomeView(), // 0
    const BookView(), // 1
    const OrderListView(), // 2
    const BestSellingView(), // 3
    const BookPdfView(), // 4
    const SpecialOffersView(), // 5
    const ProfileView(), // 6 (Moved)
    const ContactUsView(), // 7
    const AboutUsView(), // 8
  ];

  // 2. Titles List
  final List<String> _titles = [
    'Home',
    'Books',
    'Order List',
    'Best Selling',
    'Book PDF Free',
    'Special Offers',
    'Profile', // 6
    'Contact Us',
    'About Us',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().onOrderSuccess = (index) {
        setState(() {
          _selectedIndex = index;
        });
      };
    });
  }

  // Maps the 9 pages to the 5 BottomBar icons
  int _getBottomBarIndex(int index) {
    if (index == 6) return 4; // Map Profile Page to 5th Icon
    if (index > 3) return 0; // Map PDF/Offers/Contact/About to 1st Icon (Home)
    return index; // 0=Home, 1=Books, 2=Order, 3=BestSeller
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the selected item is one of the 5 items in the BottomBar
    final bool isBottomBarPage = [0, 1, 2, 3, 6].contains(_selectedIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
      drawer: AppSidebar(
        currentRoute: _titles[_selectedIndex],
        onIndexChanged: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getBottomBarIndex(_selectedIndex),
        onTap: (index) {
          setState(() {
            // Map the 5th icon click (index 4) back to Profile Page (index 6)
            if (index == 4) {
              _selectedIndex = 6;
            } else {
              _selectedIndex = index;
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: isBottomBarPage
            ? AppColors.accent
            : AppColors.textSecondary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Books'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Order',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Best Seller'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
