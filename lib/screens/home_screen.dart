import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import 'catalog_screen.dart';
import 'cart_screen.dart';
import 'admin_screen.dart';
import '../widgets/perfume_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mohammed Dhair Perfumes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.amber),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen()));
            },
            tooltip: 'Admin Panel',
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                },
              ),
              if (store.cart.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                    child: Text('${store.cart.length}', style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: store.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black, Color(0xFF222222)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Luxury Fragrances',
                          style: TextStyle(color: Colors.amber, fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Discover the signature collection by Mohammed Dhair. Crafted with elegance and passion.',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const CatalogScreen()));
                          },
                          child: const Text('Explore Full Catalog', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Featured Perfumes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const CatalogScreen()));
                          },
                          child: const Text('View All', style: TextStyle(color: Colors.amber)),
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: store.perfumes.length > 4 ? 4 : store.perfumes.length,
                    itemBuilder: (context, index) {
                      return PerfumeCard(perfume: store.perfumes[index]);
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}