import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'address_page.dart';
import 'login.dart'; // Import the LoginPage
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the CartModel
    final cartProvider = Provider.of<CartModel>(context);

    // Check if the user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: cartProvider.cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartProvider.cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            item.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            '₹${item.price} x ${item.quantity} = ₹${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  cartProvider.removeItemQuantity(index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  cartProvider.addItem(
                                    item.name,
                                    item.image,
                                    item.price,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  cartProvider.removeItem(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${cartProvider.totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            if (user == null) {
                              // If user is not logged in, show login page
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            } else {
                              // If user is logged in, proceed to the Address Page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddressPage(
                                    cartItems: cartProvider.cartItems
                                        .map((item) => {
                                          'name': item.name,
                                          'image': item.image,
                                          'price': item.price,
                                          'quantity': item.quantity,
                                        })
                                        .toList(),
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Proceed to Checkout',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
