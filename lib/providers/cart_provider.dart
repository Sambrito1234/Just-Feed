import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class CartModel extends ChangeNotifier {
  final List<CartItem> _cartItems = [];

  // Getter for cart items
  List<CartItem> get cartItems => _cartItems;

  // Method to add an item
  void addItem(String name, String image, double price) {
    final existingItemIndex =
        _cartItems.indexWhere((item) => item.name == name);
    if (existingItemIndex >= 0) {
      _cartItems[existingItemIndex].quantity++;
    } else {
      _cartItems.add(
        CartItem(name: name, image: image, price: price),
      );
    }
    notifyListeners();
  }

  // Method to remove an item entirely
  void removeItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // Method to decrease item quantity
  void removeItemQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
    } else {
      _cartItems.removeAt(index);
    }
    notifyListeners();
  }

  // Method to clear the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Getter for total price
  double get totalPrice {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  // Getter for total items in the cart
  int get totalItems {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }
}
