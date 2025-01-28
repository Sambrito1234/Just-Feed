import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need Help?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'For any issues or queries, feel free to contact us:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: const Text('support@justfeed.com'),
              onTap: () async {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'support@justfeed.com',
                );
                if (await canLaunch(emailUri.toString())) {
                  await launch(emailUri.toString());
                } else {
                  // Handle the error
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: const Text('+91 12345 67890'),
              onTap: () async {
                final Uri phoneUri = Uri(
                  scheme: 'tel',
                  path: '+911234567890',
                );
                if (await canLaunch(phoneUri.toString())) {
                  await launch(phoneUri.toString());
                } else {
                  // Handle the error
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Chat with Us'),
              subtitle: const Text('Available 24/7'),
              onTap: () {
                // Handle chat action
                // You can integrate a chat SDK or navigate to a chat screen
              },
            ),
          ],
        ),
      ),
    );
  }
}