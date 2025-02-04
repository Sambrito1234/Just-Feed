import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'thankyoupage.dart';
import 'login.dart';
import '../services/upi_service.dart' as upi_service; // Make sure to import your UpiService
import 'payment_failed.dart' as screen; // Import the PaymentFailedPage

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
  bool isProcessingPayment = false;

  Future<void> _confirmOrder() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If no user is logged in, navigate to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
    }

    setState(() {
      isProcessingPayment = true; // Start processing payment
    });

    if (selectedPaymentMethod == 'UPI') {
      // Handle UPI payment
      try {
        bool paymentSuccess = await upi_service.UpiService.initiateUpiPayment(
          context: context,
          amount: widget.totalPrice,
          upiId: 'sambritoghosh9641@oksbi', // Replace with your actual UPI ID
          receiverName: 'JustFeed',
        );
        if (!paymentSuccess) {
          // If payment failed, navigate to PaymentFailedPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const screen.PaymentFailedPage()),
          );
          return;
        }
      } catch (e) {
        setState(() {
          isProcessingPayment = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e')),
        );
        return;
      }
    }

    // Store order details in Firestore after payment success
    try {
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'items': widget.cartItems,
        'totalPrice': widget.totalPrice,
        'paymentMethod': selectedPaymentMethod,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the cart
      Provider.of<CartModel>(context, listen: false).clearCart();

      // Navigate to Thank You page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ThankYouPage()),
      );
    } catch (e) {
      setState(() {
        isProcessingPayment = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order confirmation failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  final item = widget.cartItems[index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                    trailing: Text('₹${item['price']}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Total: ₹${widget.totalPrice}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text('Cash on Delivery'),
              leading: Radio<String>(
                value: 'Cash on Delivery',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('UPI'),
              leading: Radio<String>(
                value: 'UPI',
                groupValue: selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: isProcessingPayment ? null : _confirmOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: isProcessingPayment
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Confirm Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
