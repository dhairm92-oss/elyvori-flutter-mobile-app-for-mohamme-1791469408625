import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../models/perfume_model.dart';

class AdminProductsTab extends StatelessWidget {
  const AdminProductsTab({super.key});

  void _showProductDialog(BuildContext context, {Perfume? perfume}) {
    final store = Provider.of<StoreProvider>(context, listen: false);
    final nameController = TextEditingController(text: perfume?.name ?? '');
    final brandController = TextEditingController(text: perfume?.brand ?? 'Mohammed Dhair');
    final categoryController = TextEditingController(text: perfume?.category ?? 'Luxury');
    final priceController = TextEditingController(text: perfume != null ? perfume.price.toString() : '');
    final descController = TextEditingController(text: perfume?.description ?? '');
    final imageController = TextEditingController(text: perfume?.imageUrl ?? '');
    final stockController = TextEditingController(text: perfume != null ? perfume.stock.toString() : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(perfume == null ? 'Add New Perfume' : 'Edit Perfume'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: brandController, decoration: const InputDecoration(labelText: 'Brand')),
              TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
              TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (\$0.00)')),
              TextField(controller: stockController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Stock Quantity')),
              TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Image URL')),
              TextField(controller: descController, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.amber),
            onPressed: () {
              if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                final newPerfume = Perfume(
                  id: perfume?.id,
                  name: nameController.text,
                  brand: brandController.text,
                  category: categoryController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  description: descController.text,
                  imageUrl: imageController.text.isNotEmpty ? imageController.text : 'https://images.unsplash.com/photo-1523293182086-7651a899d37f?w=600',
                  stock: int.tryParse(stockController.text) ?? 10,
                );
                if (perfume == null) {
                  store.addPerfume(newPerfume);
                } else {
                  store.updatePerfume(newPerfume);
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: store.perfumes.length,
        itemBuilder: (context, index) {
          final p = store.perfumes[index];
          return ListTile(
            leading: Image.network(p.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
            title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Price: \$${p.price.toStringAsFixed(2)} | Stock: ${p.stock}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showProductDialog(context, perfume: p),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => store.deletePerfume(p.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.amber,
        onPressed: () => _showProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}