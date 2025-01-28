import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/order_history_provider.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'thankyoupage.dart';
import 'login.dart'; // Import the LoginPage
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class OrderConfirmationPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalPrice;

  const OrderConfirmationPage({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  _OrderConfirmationPageState createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  String? selectedPaymentMethod = 'Cash on Delivery'; // Default payment method

  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Total Price:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('₹${widget.totalPrice}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('Select Payment Method:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Cash on Delivery'),
                  value: 'Cash on Delivery',
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Card/UPI (Coming Soon)'),
                  value: 'Card/UPI',
                  groupValue: selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  if (user == null) {
                    // If the user is not logged in, redirect to login page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  } else {
                    // Proceed with order confirmation
                    _confirmOrder(context, user);
                  }
                },
                child: const Text('Confirm Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmOrder(BuildContext context, User user) {
    // Get the current time for the order date
    String orderDate = DateTime.now().toString();

    // Create an order object with the necessary details
    Map<String, dynamic> newOrder = {
      'restaurant': 'Sample Restaurant', // Replace with actual restaurant name
      'items': widget.cartItems.map((item) => item['name']).toList(),
      'total': widget.totalPrice,
      'date': orderDate,
    };

    // Add the order to the order history provider
    Provider.of<OrderHistoryProvider>(context, listen: false).addOrder(newOrder);

    // Clear the cart after order
    Provider.of<CartModel>(context, listen: false).clearCart();

    // Navigate to Thank You Page after confirming the order
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const ThankYouPage(),
      ),
      (Route<dynamic> route) => false, // Clear the previous routes
    );
  }
}
