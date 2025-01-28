import 'package:flutter/material.dart';
import 'restaurantpage.dart';

class RestaurantListPage extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> restaurants;

  const RestaurantListPage({
    required this.category,
    required this.restaurants,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Restaurants'),
        backgroundColor: Colors.orange,
      ),
      body: restaurants.isEmpty
          ? const Center(
              child: Text(
                'No restaurants found for this category!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantPage(
                          name: restaurant['name'] ?? 'Unnamed Restaurant',
                          cuisine: restaurant['cuisine'] ?? 'Cuisine not specified',
                          menu: List<Map<String, dynamic>>.from(restaurant['menu'] ?? []),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: Row(
                      children: [
                        // Restaurant Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            restaurant['image'] ?? 'assets/images/placeholder.jpg',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Restaurant Details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  restaurant['name'] ?? 'Unnamed Restaurant',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  restaurant['cuisine'] ?? 'Cuisine not specified',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
