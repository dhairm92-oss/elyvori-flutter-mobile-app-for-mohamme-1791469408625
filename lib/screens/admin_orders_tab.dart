import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';

class AdminOrdersTab extends StatelessWidget {
  const AdminOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);

    if (store.orders.isEmpty) {
      return const Center(child: Text('No orders received yet.'));
    }

    return ListView.builder(
      itemCount: store.orders.length,
      itemBuilder: (context, index) {
        final order = store.orders[index];
        return Card(
          margin: const EdgeInsets.all(10),
          child: ExpansionTile(
            title: Text('Order #${order.id} - ${order.customerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Total: \$${order.totalAmount.toStringAsFixed(2)} | Date: ${order.date}\nStatus: ${order.status}'),
            isThreeLine: true,
            trailing: DropdownButton<String>(
              value: order.status,
              items: ['Pending', 'Processing', 'Delivered', 'Cancelled'].map((status) {
                return DropdownMenuItem(value: status, child: Text(status));
              }).toList(),
              onChanged: (newStatus) {
                if (newStatus != null) {
                  store.updateOrderStatus(order.id!, newStatus);
                }
              },
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone: ${order.phone}'),
                    Text('Address: ${order.address}'),
                    const Divider(),
                    const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${item.perfumeName} x${item.quantity}'),
                          Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}