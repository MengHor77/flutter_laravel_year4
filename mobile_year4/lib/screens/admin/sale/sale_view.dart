import 'today_sale.dart';
import 'total_sale.dart';
import 'sale_detail.dart';
import 'search_sale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile_year4/colors.dart';
import 'package:mobile_year4/providers/sale_provider.dart';

class SaleView extends StatefulWidget {
  final VoidCallback openDrawer;
  const SaleView({super.key, required this.openDrawer});

  @override
  State<SaleView> createState() => _SaleViewState();
}

class _SaleViewState extends State<SaleView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch both summary and details on load
      context.read<SaleProvider>().fetchSales();
      context.read<SaleProvider>().fetchSaleDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final saleProvider = context.watch<SaleProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Sales Report"),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
        actions: [
          // ✅ ADD THIS SEARCH BUTTON
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SaleSearchDelegate(
                  saleDetails: saleProvider.saleDetails,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              saleProvider.fetchSales();
              saleProvider.fetchSaleDetails();
            },
          ),
        ],
      ),
      body: _buildBody(saleProvider),
    );
  }

  Widget _buildBody(SaleProvider provider) {
    if (provider.isLoading && provider.saleDetails.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: AppColors.danger),
            Text(
              "Error: ${provider.errorMessage}",
              style: const TextStyle(color: AppColors.textPrimary),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () => provider.fetchSales(),
              child: const Text(
                "Retry",
                style: TextStyle(color: AppColors.textOnDark),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.accent,
      onRefresh: () async {
        await provider.fetchSales();
        await provider.fetchSaleDetails();
      },
      child: CustomScrollView(
        slivers: [
          // 1. Summary Cards Section
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                TodaySaleCard(amount: provider.todaySales),
                const SizedBox(height: 20),
                TotalSaleCard(amount: provider.monthlyRevenue),
                const SizedBox(height: 30),
                const Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Divider(),
              ]),
            ),
          ),

          // 2. Transaction Details Section (Shown as Column/List)
          provider.saleDetails.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 60,
                          color: AppColors.textSecondary,
                        ),
                        Text(
                          "No transactions found",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final sale = provider.saleDetails[index];
                      return SaleDetailItem(
                        sale: sale,
                      ); // Custom widget for clean code
                    }, childCount: provider.saleDetails.length),
                  ),
                ),
        ],
      ),
    );
  }
}
