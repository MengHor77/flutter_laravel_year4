import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/colors.dart';
import 'package:mobile_year4/models/book_model.dart';
import 'package:mobile_year4/providers/book_provider.dart';
import 'package:mobile_year4/widgets/frontent/menu_sidebar.dart';
import 'package:mobile_year4/screens/frontend/home/home_view.dart';
import 'package:mobile_year4/screens/frontend/book/book_view.dart';
import 'package:mobile_year4/screens/frontend/profile/profile.dart';
import 'package:mobile_year4/widgets/frontent/seach_book_global.dart';
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

  final List<Widget> _pages = [
    const HomeView(), // 0
    const BookView(), // 1
    const OrderListView(), // 2
    const BestSellingView(), // 3
    const BookPdfView(), // 4
    const SpecialOffersView(), // 5
    const ProfileView(), // 6
    const ContactUsView(), // 7
    const AboutUsView(), // 8
  ];

  final List<String> _titles = [
    'Home',
    'Books',
    'Order List',
    'Best Selling',
    'Book PDF Free',
    'Special Offers',
    'Profile',
    'Contact Us',
    'About Us',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().onOrderSuccess = (index) {
        setState(() => _selectedIndex = index);
      };
    });
  }

  int _getBottomBarIndex(int index) {
    if (index == 6) return 4;
    if (index > 3) return 0;
    return index;
  }

  void _onSearchPressed() {
    final bookProvider = context.read<BookProvider>();
    List<Book> searchList = [];
    String hint = "Search...";

    if (_selectedIndex == 1) {
      searchList = bookProvider.books;
      hint = "Search Books...";
    } else if (_selectedIndex == 3) {
      searchList = bookProvider.bestSellers;
      hint = "Search Best Sellers...";
    }

    showSearch(
      context: context,
      delegate: GlobalBookSearchDelegate(
        items: searchList,
        hintText: hint,
        onAddToCart: (book) => handleAddToCartGlobal(context, book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isBottomBarPage = [0, 1, 2, 3, 6].contains(_selectedIndex);
    final bool showSearchIcon = [1, 3].contains(_selectedIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        actions: [
          if (showSearchIcon)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _onSearchPressed,
            ),
          const SizedBox(width: 8),
        ],
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
            _selectedIndex = (index == 4) ? 6 : index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: isBottomBarPage
            ? AppColors.accent
            : AppColors.textPrimary,
        unselectedItemColor: AppColors.textPrimary,
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
