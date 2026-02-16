import 'package:flutter/material.dart';
import 'package:mobile_year4/colors.dart';
import 'package:mobile_year4/widgets/frontent/menu_sidebar.dart';
import 'package:mobile_year4/screens/frontend/home/home_view.dart';
import 'package:mobile_year4/screens/frontend/book/book_view.dart';
import 'package:mobile_year4/screens/frontend/order_list/order_list_view.dart';
import 'package:mobile_year4/screens/frontend/best_selling_view/best_selling_view.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  // បញ្ជីទំព័រដែលបង្ហាញក្នុង IndexedStack
  final List<Widget> _pages = [
    const HomeView(), // Index 0
    const BookView(), // Index 1
    const OrderListView(), // Index 2
    const BestSellingView(), // Index 3
    const Center(child: Text("Profile Page")), // Index 4
  ];

  // បញ្ជីចំណងជើង AppBar ទៅតាម Index
  final List<String> _titles = [
    'Home',
    'Books',
    'Order List',
    'Best Selling',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // AppBar តែមួយសម្រាប់គ្រប់ទំព័រ (នឹងបង្ហាញប៊ូតុង Menu ជានិច្ច)
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),

      // Sidebar ដែលទទួល callback ដើម្បីប្តូរ Index
      drawer: AppSidebar(
        currentRoute: _titles[_selectedIndex],
        onIndexChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),

      // ប្រើ IndexedStack ដើម្បីកុំឱ្យបាត់ Bottom Bar និង AppBar
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: (_selectedIndex > 3) ? 3 : _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Book'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Best Seller',
          ), // Added this
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
