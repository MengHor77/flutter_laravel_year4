import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/colors.dart';
import 'package:mobile_year4/api_config.dart';
import 'package:mobile_year4/models/book_model.dart';
import 'package:mobile_year4/providers/book_provider.dart';
import 'package:mobile_year4/providers/language_provider.dart';
import 'package:mobile_year4/widgets/frontent/menu_sidebar.dart';
import '../../screens/frontend/book_pdf_free/download_book.dart';
import 'package:mobile_year4/providers/notification_provider.dart';
import 'package:mobile_year4/screens/frontend/home/home_view.dart';
import 'package:mobile_year4/screens/frontend/book/book_view.dart';
import 'package:mobile_year4/providers/free_book_pdf_provider.dart';
import 'package:mobile_year4/screens/frontend/profile/profile.dart';
import 'package:mobile_year4/providers/special_offers_provider.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  int _getNavIndex(int index) {
    if (index == 0) return 0; // Home
    if (index == 1) return 1; // Books
    if (index == 2) return 2; // Order List
    if (index == 3) return 3; // Best Selling
    if (index == 6) return 4; // Profile
    return -1;
  }

  final List<Widget> _pages = [
    const HomeView(),
    const BookView(),
    const OrderListView(),
    const BestSellingView(),
    const BookPdfView(),
    const SpecialOffersView(),
    const ProfileView(),
    const ContactUsView(),
    const AboutUsView(),
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
      context.read<NotificationProvider>().fetchNotifications();
    });
  }

  Book _mapOfferToBook(Map offerData) {
    return Book(
      id: offerData['book_id'].toString(),
      name: offerData['book']['name'] ?? 'Unknown',
      author: offerData['book']['author'] ?? 'Unknown',
      price: offerData['book']['price'].toString(),
      displayPrice: offerData['offer_price'].toString(),
      image: offerData['book']['image'] ?? '',
      categoryName: 'Special Offer',
      isOnSale: true,
    );
  }

  void _handlePdfDownload(Book book) {
    final pdfProvider = context.read<FreeBookPdfProvider>();
    try {
      final originalPdf = pdfProvider.freeBooks.firstWhere(
        (element) => element.id.toString() == book.id,
      );

      String urlPath = originalPdf.pdfFile;
      String fullPdfUrl = '';

      if (urlPath.startsWith('http')) {
        Uri currentUri = Uri.parse(ApiConfig.baseUrl);
        fullPdfUrl = urlPath
            .replaceAll('127.0.0.1', currentUri.host)
            .replaceAll('localhost', currentUri.host);
      } else {
        String cleanPath = urlPath.startsWith('/')
            ? urlPath.substring(1)
            : urlPath;
        fullPdfUrl = cleanPath.startsWith('storage/')
            ? "${ApiConfig.baseUrl}/$cleanPath"
            : "${ApiConfig.baseUrl}/storage/$cleanPath";
      }
      BookSaver.saveAndNotify(fullPdfUrl, "${book.name}.pdf", context);
    } catch (e) {
      debugPrint("Search download error: $e");
    }
  }

  void _onSearchPressed() {
    final bookProvider = context.read<BookProvider>();
    final specialProvider = context.read<SpecialOffersProvider>();
    final pdfProvider = context.read<FreeBookPdfProvider>();

    List<Book> searchList = [];
    String hint = "Search...";

    if (_selectedIndex == 1) {
      searchList = bookProvider.books;
      hint = "Search Books...";
    } else if (_selectedIndex == 3) {
      searchList = bookProvider.bestSellers;
      hint = "Search Best Sellers...";
    } else if (_selectedIndex == 4) {
      searchList = pdfProvider.freeBooks
          .map(
            (pdf) => Book(
              id: pdf.id.toString(),
              name: pdf.name,
              author: pdf.author,
              price: "0",
              displayPrice: "FREE",
              image: pdf.image ?? '',
              categoryName: "Free PDF",
              isOnSale: false,
            ),
          )
          .toList();
      hint = "Search Free PDFs...";
    } else if (_selectedIndex == 5) {
      searchList = specialProvider.offers
          .map((o) => _mapOfferToBook(o))
          .toList();
      hint = "Search Special Offers...";
    }

    showSearch(
      context: context,
      delegate: GlobalBookSearchDelegate(
        items: searchList,
        hintText: hint,
        onAddToCart: (book) {
          if (_selectedIndex == 4) {
            _handlePdfDownload(book);
          } else {
            handleAddToCartGlobal(context, book);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  Detect Dark Mode status
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool showSearchIcon = [1, 3, 4, 5].contains(_selectedIndex);
    final lang = context.watch<LanguageProvider>();
    final List<String> localizedTitles = [
      lang.translate('home'),
      lang.translate('books'),
      lang.translate('orders'),
      lang.translate('best_seller'),
      lang.translate('book_pdf_free'),
      lang.translate('special_offers'),
      lang.translate('profile'),
      lang.translate('contact_us'),
      lang.translate('about_us'),
    ];

    return Scaffold(
      key: _scaffoldKey,
      //  Dynamic background for the overall screen
      backgroundColor: AppColors.getBackground(isDark),
      appBar: AppBar(
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(
            fontWeight: FontWeight.bold, // ធ្វើឱ្យអក្សរដិតដើម្បីឱ្យ "ភ្លឺ"
            fontSize: lang.isKhmer ? 20 : 18, // អក្សរខ្មែរគួរតែធំជាងបន្តិច
          ),
        ),
        // Keep accent color for consistency or dim it if you prefer
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
        onIndexChanged: (index) => setState(() => _selectedIndex = index),
      ),
      // IndexedStack maintains state of all pages
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        //  Dark mode compatible background for the bar
        backgroundColor: AppColors.getCardBg(isDark),
        currentIndex: _getNavIndex(_selectedIndex) == -1
            ? 0
            : _getNavIndex(_selectedIndex),
        onTap: (index) =>
            setState(() => _selectedIndex = (index == 4) ? 6 : index),
        type: BottomNavigationBarType.fixed,
        //  Dynamic active/inactive colors
        selectedItemColor: _getNavIndex(_selectedIndex) == -1
            ? AppColors.getTextPrimary(isDark)
            : AppColors.accent, // color BottomNavigationBar
        unselectedItemColor: AppColors.getTextPrimary(isDark),
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
