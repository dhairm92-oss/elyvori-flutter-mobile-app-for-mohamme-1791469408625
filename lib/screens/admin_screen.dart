import 'package:flutter/material.dart';
import 'provider_admin_tab.dart'; // contained inside or separate
import 'admin_products_tab.dart';
import 'admin_orders_tab.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Store Admin Panel'),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.amber),
          titleTextStyle: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
          bottom: const TabBar(
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(icon: Icon(Icons.inventory), text: 'Products'),
              Tab(icon: Icon(Icons.receipt_long), text: 'Orders'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AdminProductsTab(),
            AdminOrdersTab(),
          ],
        ),
      ),
    );
  }
}
