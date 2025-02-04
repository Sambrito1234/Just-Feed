import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_history_provider.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderHistoryProvider = Provider.of<OrderHistoryProvider>(context);

    // Fetch order history when the page loads
    Future.microtask(() => orderHistoryProvider.fetchOrderHistory());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.orange,
      ),
      body: Consumer<OrderHistoryProvider>(
        builder: (context, orderHistoryProvider, child) {
          if (orderHistoryProvider.orderHistory.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          return ListView.builder(
            itemCount: orderHistoryProvider.orderHistory.length,
            itemBuilder: (context, index) {
              final order = orderHistoryProvider.orderHistory[index];
              final orderTimestamp = order['timestamp']?.toDate();
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Order #${order['id']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total: ₹${order['totalPrice']}'),
                      Text('Payment Method: ${order['paymentMethod']}'),
                      if (orderTimestamp != null)
                        Text(
                          'Date: ${orderTimestamp.day}-${orderTimestamp.month}-${orderTimestamp.year}',
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      // Add functionality if needed (e.g., view order details)
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
