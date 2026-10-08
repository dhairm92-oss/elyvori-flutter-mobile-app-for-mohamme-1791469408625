import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/perfume_model.dart';
import '../providers/store_provider.dart';

class PerfumeDetailScreen extends StatelessWidget {
  final Perfume perfume;
  const PerfumeDetailScreen({super.key, required this.perfume});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.amber),
        title: Text(perfume.name, style: const TextStyle(color: Colors.amber)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 320,
              width: double.infinity,
              color: Colors.grey[100],
              child: Image.network(
                perfume.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(perfume.category, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.amber,
                      ),
                      Text(
                        '\$${perfume.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    perfume.name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Brand: ${perfume.brand}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'In Stock: ${perfume.stock} units',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: perfume.stock > 0 ? Colors.green : Colors.red),
                  ),
                  const Divider(height: 32),
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    perfume.description,
                    style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: perfume.stock > 0
                          ? () {
                              store.addToCart(perfume);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${perfume.name} added to bag!')),
                              );
                            }
                          : null,
                      child: const Text('Add to Shopping Bag', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}