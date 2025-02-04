import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderHistoryProvider extends ChangeNotifier {
  // List to hold the order history
  List<Map<String, dynamic>> _orderHistory = [];

  // Getter for order history
  List<Map<String, dynamic>> get orderHistory => _orderHistory;

  // Method to fetch order history from Firestore
  Future<void> fetchOrderHistory() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('timestamp', descending: true)
        .get();

    _orderHistory = querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'items': List<Map<String, dynamic>>.from(doc['items']),
        'totalPrice': doc['totalPrice'],
        'paymentMethod': doc['paymentMethod'],
        'timestamp': doc['timestamp'],
      };
    }).toList();

    notifyListeners();
  }

  // Method to add a new order to the history
  void addOrder(Map<String, dynamic> order) {
    _orderHistory.add(order);
    notifyListeners();  // Notify listeners so UI can update
  }

  // Optionally, method to clear order history (if needed)
  void clearOrderHistory() {
    _orderHistory.clear();
    notifyListeners();
  }

  // You can also implement other methods like removeOrder if needed
  void removeOrder(int index) {
    _orderHistory.removeAt(index);
    notifyListeners();
  }
}