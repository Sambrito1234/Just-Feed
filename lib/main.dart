import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen/homepage.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart'; // Import CartModel
import 'providers/address_provider.dart'; // Import AddressProvider
import 'screen/login.dart'; // Import LoginPage
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'providers/order_history_provider.dart'; // Import OrderHistoryProvider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase for web or other platforms
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBSiRttWSLmBPGUbrXNWH6zf9SHo5HZcfY",
          authDomain: "fastfeed-184bf.firebaseapp.com",
          projectId: "fastfeed-184bf",
          storageBucket: "fastfeed-184bf.appspot.com",
          messagingSenderId: "47985026537",
          appId: "1:47985026537:web:5e31e9cb9f1b8006601778",
          measurementId: "G-LDCBQGV35V",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }

  // Once Firebase is initialized, run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()), // Cart provider
        ChangeNotifierProvider(create: (_) => AddressProvider()), // Address provider
        ChangeNotifierProvider(create: (_) => OrderHistoryProvider()), // Order History provider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food Delivery Platform',
        theme: ThemeData(primarySwatch: Colors.orange),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(), // Stream to check auth state
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // If user is authenticated, show HomePage
              if (snapshot.hasData) {
                return const HomePage();
              } else {
                // If user is not authenticated, show LoginPage
                return const LoginPage();
              }
            }
            return const CircularProgressIndicator(); // Show loading while checking auth status
          },
        ),
      ),
    );
  }
}
