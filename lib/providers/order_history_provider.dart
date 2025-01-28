import 'package:flutter/material.dart';

class OrderHistoryProvider extends ChangeNotifier {
  // List to hold the order history
  final List<Map<String, dynamic>> _orderHistory = [];

  // Getter for order history
  List<Map<String, dynamic>> get orderHistory => _orderHistory;

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
