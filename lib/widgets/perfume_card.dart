import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/perfume_model.dart';
import '../screens/perfume_detail_screen.dart';
import '../providers/store_provider.dart';

class PerfumeCard extends StatelessWidget {
  final Perfume perfume;
  const PerfumeCard({super.key, required this.perfume});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => PerfumeDetailScreen(perfume: perfume)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  perfume.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(perfume.brand, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(
                    perfume.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${perfume.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13),
                      ),
                      InkWell(
                        onTap: perfume.stock > 0
                            ? () {
                                store.addToCart(perfume);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${perfume.name} added to bag'), duration: const Duration(milliseconds: 800)),
                                );
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: perfume.stock > 0 ? Colors.black : Colors.grey,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.add_shopping_cart, size: 16, color: Colors.amber),
                        ),
                      ),
                    ],
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