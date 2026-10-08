class OrderItem {
  final int perfumeId;
  final String perfumeName;
  final double price;
  final int quantity;

  OrderItem({
    required this.perfumeId,
    required this.perfumeName,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap(int orderId) {
    return {
      'order_id': orderId,
      'perfume_id': perfumeId,
      'perfume_name': perfumeName,
      'price': price,
      'quantity': quantity,
    };
  }
}

class Order {
  final int? id;
  final String customerName;
  final String address;
  final String phone;
  final double totalAmount;
  final String status;
  final String date;
  final List<OrderItem> items;

  Order({
    this.id,
    required this.customerName,
    required this.address,
    required this.phone,
    required this.totalAmount,
    required this.status,
    required this.date,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_name': customerName,
      'address': address,
      'phone': phone,
      'total_amount': totalAmount,
      'status': status,
      'date': date,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, List<OrderItem> items) {
    return Order(
      id: map['id'] as int?,
      customerName: map['customer_name'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      totalAmount: (map['total_amount'] as num).toDouble(),
      status: map['status'] as String,
      date: map['date'] as String,
      items: items,
    );
  }
}
