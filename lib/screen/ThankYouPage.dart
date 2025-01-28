import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/homepage.dart';

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 100),
              const SizedBox(height: 20),
              const Text(
                'Thank You for Your Order!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your order has been placed successfully. We will notify you once it is ready.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
                onPressed: () {
                  // Navigate back to the home screen
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()), // Replace with your home page
                    (Route<dynamic> route) => false, // Remove all previous routes
                  );
                },
                child: const Text('Go to Home', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
