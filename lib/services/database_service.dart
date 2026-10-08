import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/perfume_model.dart';
import '../models/order_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'mohammed_dhair_perfume.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE perfumes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        category TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        stock INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_name TEXT NOT NULL,
        address TEXT NOT NULL,
        phone TEXT NOT NULL,
        total_amount REAL NOT NULL,
        status TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE order_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER NOT NULL,
        perfume_id INTEGER NOT NULL,
        perfume_name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
      )
    ''');

    // Insert Initial Seed Data
    await db.insert('perfumes', {
      'name': 'Royal Amber',
      'brand': 'Mohammed Dhair',
      'category': 'Luxury',
      'price': 120.0,
      'description': 'An opulent blend of amber, oud, and warm spices designed for royalty.',
      'imageUrl': 'https://images.unsplash.com/photo-1523293182086-7651a899d37f?w=600',
      'stock': 15,
    });

    await db.insert('perfumes', {
      'name': 'Midnight Velvet',
      'brand': 'Mohammed Dhair',
      'category': 'Evening',
      'price': 95.0,
      'description': 'Mysterious and seductive notes of black orchid, vanilla, and dark patchouli.',
      'imageUrl': 'https://images.unsplash.com/photo-1594035910387-fea47794261f?w=600',
      'stock': 8,
    });

    await db.insert('perfumes', {
      'name': 'Desert Breeze',
      'brand': 'Mohammed Dhair',
      'category': 'Fresh',
      'price': 85.0,
      'description': 'Refreshing citrus combined with clean white musk and oceanic accords.',
      'imageUrl': 'https://images.unsplash.com/photo-1583445013765-46c20c4a6772?w=600',
      'stock': 20,
    });

    await db.insert('perfumes', {
      'name': 'Golden Oud',
      'brand': 'Mohammed Dhair',
      'category': 'Luxury',
      'price': 150.0,
      'description': 'Pure aged Cambodian oud infused with golden saffron and rose absolute.',
      'imageUrl': 'https://images.unsplash.com/photo-1541643600914-78b084683601?w=600',
      'stock': 5,
    });
  }

  // Perfume CRUD
  Future<List<Perfume>> getPerfumes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('perfumes');
    return List.generate(maps.length, (i) => Perfume.fromMap(maps[i]));
  }

  Future<int> insertPerfume(Perfume perfume) async {
    final db = await database;
    return await db.insert('perfumes', perfume.toMap());
  }

  Future<int> updatePerfume(Perfume perfume) async {
    final db = await database;
    return await db.update(
      'perfumes',
      perfume.toMap(),
      where: 'id = ?',
      whereArgs: [perfume.id],
    );
  }

  Future<int> deletePerfume(int id) async {
    final db = await database;
    return await db.delete(
      'perfumes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Order Operations
  Future<int> createOrder(Order order) async {
    final db = await database;
    int orderId = await db.insert('orders', order.toMap());
    for (var item in order.items) {
      await db.insert('order_items', item.toMap(orderId));
      // Deduct stock
      await db.rawUpdate(
        'UPDATE perfumes SET stock = stock - ? WHERE id = ?',
        [item.quantity, item.perfumeId],
      );
    }
    return orderId;
  }

  Future<List<Order>> getOrders() async {
    final db = await database;
    final List<Map<String, dynamic>> orderMaps = await db.query('orders', orderBy: 'id DESC');
    List<Order> orders = [];
    for (var oMap in orderMaps) {
      int orderId = oMap['id'];
      final List<Map<String, dynamic>> itemMaps = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );
      List<OrderItem> items = itemMaps.map((iMap) => OrderItem(
        perfumeId: iMap['perfume_id'],
        perfumeName: iMap['perfume_name'],
        price: iMap['price'],
        quantity: iMap['quantity'],
      )).toList();
      orders.add(Order.fromMap(oMap, items));
    }
    return orders;
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    final db = await database;
    await db.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }
}
