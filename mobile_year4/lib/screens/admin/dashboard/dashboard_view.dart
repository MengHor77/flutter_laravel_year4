import 'revenue_card.dart';
import '../../../colors.dart';
import 'total_book_card.dart';
import 'active_order_card.dart';
import 'package:flutter/material.dart';
import 'total_user_card.dart'; // Verify this file name is exactly 'total_user_card.dart'

class DashboardView extends StatelessWidget {
  final VoidCallback openDrawer;

  const DashboardView({super.key, required this.openDrawer});

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
          onPressed: openDrawer,
        ),
      ),
      // Using a CustomScrollView or ListView with RefreshIndicator 
      // is more reliable for "Pull to Refresh" than a basic GridView.
      body: RefreshIndicator(
        onRefresh: () async {
          // This triggers a rebuild of the dashboard
          (context as Element).markNeedsBuild();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            physics: const AlwaysScrollableScrollPhysics(), // Important for RefreshIndicator
            children: const [
              TotalBookCard(),
              TotalUserCard(),
              ActiveOrderCard(),
              RevenueCard(),
            ],
          ),
        ),
      ),
    );
  }
}