import 'revenue_card.dart';
import '../../../colors.dart';
import 'total_book_card.dart';
import 'total_user_card.dart';
import 'total_monthly_order_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../../../providers/sale_provider.dart'; 

class DashboardView extends StatefulWidget {
  final VoidCallback openDrawer;
  const DashboardView({super.key, required this.openDrawer});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SaleProvider>(context, listen: false).fetchSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Admin Dashboard"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<SaleProvider>(context, listen: false).fetchSales();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              TotalBookCard(),
              TotalUserCard(),
              TotalMonthlyOrderCard(),
              RevenueCard(), 
            ],
          ),
        ),
      ),
    );
  }
}
