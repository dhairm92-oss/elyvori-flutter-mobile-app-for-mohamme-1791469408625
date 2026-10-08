import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../widgets/perfume_card.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    
    final categories = ['All', ...store.perfumes.map((p) => p.category).toSet().toList()];

    final filteredPerfumes = store.perfumes.where((p) {
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfume Catalog'),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.amber),
        titleTextStyle: const TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search perfumes or brands...',
                prefixIcon: const Icon(Icons.search, color: Colors.amber),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: Colors.amber,
                    backgroundColor: Colors.grey[250],
                    labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.black87, fontWeight: FontWeight.bold),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filteredPerfumes.isEmpty
                ? const Center(child: Text('No perfumes found.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.63,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredPerfumes.length,
                    itemBuilder: (context, index) {
                      return PerfumeCard(perfume: filteredPerfumes[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
