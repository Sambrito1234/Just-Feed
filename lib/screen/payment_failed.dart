import 'package:flutter/material.dart';

class PaymentFailedPage extends StatelessWidget {
  const PaymentFailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Failed'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Unsuccessful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to OrderConfirmationPage
                Navigator.pop(context);
              },
              child: const Text("Retry Payment"),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the order confirmation screen or home screen
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text("Go Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
