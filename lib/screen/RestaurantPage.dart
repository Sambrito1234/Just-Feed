import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'cart.dart';

class RestaurantPage extends StatelessWidget {
  final String name;
  final String cuisine;
  final List<Map<String, dynamic>> menu;

  const RestaurantPage({
    required this.name,
    required this.cuisine,
    this.menu = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cuisine,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Menu Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Menu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Menu List
          Expanded(
            child: menu.isNotEmpty
                ? ListView.builder(
                    itemCount: menu.length,
                    itemBuilder: (context, index) {
                      final menuItem = menu[index];

                      final String itemName = menuItem['name'] ?? 'Unknown';
                      final String itemImage = menuItem['image'] ?? '';
                      final double itemPrice = menuItem['price'] != null
                          ? double.parse(menuItem['price'].toString())
                          : 0.0;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: ListTile(
                          leading: Image.asset(
                            itemImage,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            itemName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '₹${itemPrice.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              // Add item to cart
                              Provider.of<CartModel>(context, listen: false)
                                  .addItem(itemName, itemImage, itemPrice);

                              // Show Snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Added $itemName to the cart!',
                                  ),
                                  action: SnackBarAction(
                                    label: 'View Cart',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const CartPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            child: const Text('Add to Cart'),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No menu items available!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
