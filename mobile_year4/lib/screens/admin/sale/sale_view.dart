import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
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
    // Fetch data via Provider when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SaleProvider>().fetchSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the SaleProvider for any changes
    final saleProvider = context.watch<SaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Report"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: widget.openDrawer,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => saleProvider.fetchSales(),
          ),
        ],
      ),
      body: _buildBody(saleProvider),
    );
  }

  Widget _buildBody(SaleProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            Text("Error: ${provider.errorMessage}"),
            ElevatedButton(
              onPressed: () => provider.fetchSales(),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (provider.hasNoSales) {
      return RefreshIndicator(
        onRefresh: () => provider.fetchSales(),
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            const Center(
              child: Column(
                children: [
                  Icon(Icons.analytics_outlined, size: 80, color: Colors.grey),
                  Text("No sales recorded yet", 
                    style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchSales(),
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildSaleCard("Today's Total Sale", provider.todaySales, Colors.green),
          const Divider(height: 30),
          _buildSaleCard("Monthly Revenue", provider.monthlyRevenue, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildSaleCard(String title, double amount, Color color) {
    bool hasNoSale = amount <= 0;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      tileColor: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Text(
        hasNoSale ? "No sale yet" : "\$${amount.toStringAsFixed(2)}",
        style: TextStyle(
          fontSize: hasNoSale ? 16 : 22,
          fontWeight: FontWeight.bold,
          color: hasNoSale ? Colors.grey : color,
          fontStyle: hasNoSale ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }
}