import 'package:flutter/foundation.dart';
import '../models/perfume_model.dart';
import '../models/order_model.dart';
import '../services/database_service.dart';

class CartItem {
  final Perfume perfume;
  int quantity;

  CartItem({required this.perfume, this.quantity = 1});

  double get total => perfume.price * quantity;
}

class StoreProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Perfume> _perfumes = [];
  List<Order> _orders = [];
  final List<CartItem> _cart = [];
  bool _isLoading = false;

  List<Perfume> get perfumes => _perfumes;
  List<Order> get orders => _orders;
  List<CartItem> get cart => _cart;
  bool get isLoading => _isLoading;

  double get cartTotal => _cart.fold(0, (sum, item) => sum + item.total);

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _perfumes = await _dbService.getPerfumes();
    _orders = await _dbService.getOrders();

    _isLoading = false;
    notifyListeners();
  }

  void addToCart(Perfume perfume) {
    final index = _cart.indexWhere((item) => item.perfume.id == perfume.id);
    if (index >= 0) {
      if (_cart[index].quantity < perfume.stock) {
        _cart[index].quantity++;
      }
    } else {
      _cart.add(CartItem(perfume: perfume));
    }
    notifyListeners();
  }

  void removeFromCart(int perfumeId) {
    _cart.removeWhere((item) => item.perfume.id == perfumeId);
    notifyListeners();
  }

  void updateCartQuantity(int perfumeId, int delta) {
    final index = _cart.indexWhere((item) => item.perfume.id == perfumeId);
    if (index >= 0) {
      int newQty = _cart[index].quantity + delta;
      if (newQty > 0 && newQty <= _cart[index].perfume.stock) {
        _cart[index].quantity = newQty;
      } else if (newQty <= 0) {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<bool> checkout(String name, String address, String phone) async {
    if (_cart.isEmpty) return false;
    List<OrderItem> items = _cart.map((c) => OrderItem(
      perfumeId: c.perfume.id!,
      perfumeName: c.perfume.name,
      price: c.perfume.price,
      quantity: c.quantity,
    )).toList();

    Order newOrder = Order(
      customerName: name,
      address: address,
      phone: phone,
      totalAmount: cartTotal,
      status: 'Pending',
      date: DateTime.now().toString().substring(0, 16),
      items: items,
    );

    await _dbService.createOrder(newOrder);
    clearCart();
    await loadData();
    return true;
  }

  // Admin Actions
  Future<void> addPerfume(Perfume perfume) async {
    await _dbService.insertPerfume(perfume);
    await loadData();
  }

  Future<void> updatePerfume(Perfume perfume) async {
    await _dbService.updatePerfume(perfume);
    await loadData();
  }

  Future<void> deletePerfume(int id) async {
    await _dbService.deletePerfume(id);
    await loadData();
  }

  Future<void> updateOrderStatus(int orderId, String status) async {
    await _dbService.updateOrderStatus(orderId, status);
    await loadData();
  }
}
