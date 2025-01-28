import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_history_provider.dart';  // Import the OrderHistoryProvider

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderHistoryProvider = Provider.of<OrderHistoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
        backgroundColor: Colors.orange,
      ),
      body: orderHistoryProvider.orderHistory.isNotEmpty
          ? ListView.builder(
              itemCount: orderHistoryProvider.orderHistory.length,
              itemBuilder: (context, index) {
                final order = orderHistoryProvider.orderHistory[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(order['restaurant']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Items: ${order['items'].join(', ')}'),
                        Text('Date: ${order['date']}'),
                      ],
                    ),
                    trailing: Text('₹${order['total']}'),
                  ),
                );
              },
            )
          : const Center(
              child: Text('No orders yet!', style: TextStyle(fontSize: 16)),
            ),
    );
  }
}
