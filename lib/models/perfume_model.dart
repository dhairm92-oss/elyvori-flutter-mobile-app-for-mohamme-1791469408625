class Perfume {
  final int? id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final int stock;

  Perfume({
    this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.stock,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'stock': stock,
    };
  }

  factory Perfume.fromMap(Map<String, dynamic> map) {
    return Perfume(
      id: map['id'] as int?,
      name: map['name'] as String,
      brand: map['brand'] as String,
      category: map['category'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      stock: map['stock'] as int,
    );
  }
}
