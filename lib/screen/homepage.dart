import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart'; // Import LoginPage
import '../widgets/category_card.dart'; // CategoryCard Widget
import '../widgets/restaurant_card.dart'; // RestaurantCard Widget
import '../widgets/food_search_delegate.dart'; // FoodSearchDelegate
import 'profilepage.dart'; // Import ProfilePage
import 'cart.dart'; // Import CartPage
import 'restaurantlistpage.dart'; // Page for category-specific restaurants
import 'RestaurantPage.dart'; // Page for individual restaurant details
import 'order_history.dart';
import 'support.dart';
import 'about.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is logged in
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // If no user is logged in, navigate to LoginPage
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
      return Container(); // Return an empty container while checking
    }

    // List of restaurants with details
    final List<Map<String, dynamic>> restaurants = [
      {
        'name': 'The Food Court',
        'cuisine': '4.5 ★ | Indian, Pizza',
        'image': 'assets/images/rest1.jpg',
        'category': 'Pizza',
        'menu': [
          {'name': 'Margherita Pizza', 'price': 299, 'image': 'assets/images/pizza1.jpg'},
          {'name': 'Paneer Tikka', 'price': 249, 'image': 'assets/images/paneer.jpg'},
        ],
      },
      {
        'name': 'Burger Hub',
        'cuisine': '4.3 ★ | Burgers, Fast Food',
        'image': 'assets/images/rest2.jpg',
        'category': 'Burgers',
        'menu': [
          {'name': 'Cheeseburger', 'price': 199, 'image': 'assets/images/burger1.jpg'},
          {'name': 'Double Patty Burger', 'price': 299, 'image': 'assets/images/burger2.jpg'},
        ],
      },
      {
        'name': 'Sushi World',
        'cuisine': '4.7 ★ | Japanese, Sushi',
        'image': 'assets/images/rest3.jpg',
        'category': 'Sushi',
        'menu': [
          {'name': 'California Roll', 'price': 399, 'image': 'assets/images/sushi1.jpg'},
          {'name': 'Spicy Tuna Roll', 'price': 499, 'image': 'assets/images/sushi2.jpg'},
        ],
      },
      {
        'name': 'Sweet Treats',
        'cuisine': '4.6 ★ | Desserts, Bakery',
        'image': 'assets/images/rest4.jpg',
        'category': 'Desserts',
        'menu': [
          {'name': 'Chocolate Cake', 'price': 299, 'image': 'assets/images/dessert1.jpg'},
          {'name': 'Cupcakes', 'price': 199, 'image': 'assets/images/dessert2.jpg'},
        ],
      },
      {
        'name': 'Pasta Palace',
        'cuisine': '4.4 ★ | Italian, Pasta',
        'image': 'assets/images/rest5.jpg',
        'category': 'Pasta',
        'menu': [
          {'name': 'Spaghetti Carbonara', 'price': 349, 'image': 'assets/images/pasta1.jpg'},
          {'name': 'Penne Arrabbiata', 'price': 299, 'image': 'assets/images/pasta2.jpg'},
        ],
      },
      {
        'name': 'Taco Town',
        'cuisine': '4.5 ★ | Mexican, Tacos',
        'image': 'assets/images/rest6.jpg',
        'category': 'Tacos',
        'menu': [
          {'name': 'Chicken Tacos', 'price': 249, 'image': 'assets/images/taco1.jpg'},
          {'name': 'Beef Tacos', 'price': 299, 'image': 'assets/images/taco2.jpg'},
        ],
      },
      // Add more restaurants as needed
    ];

    // Function to filter restaurants based on category
    List<Map<String, dynamic>> filterRestaurantsByCategory(String category) {
      return restaurants.where((restaurant) => restaurant['category'] == category).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Feed'),
        backgroundColor: Colors.orange,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Open search with FoodSearchDelegate
              showSearch(
                context: context,
                delegate: FoodSearchDelegate(restaurants: restaurants),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.orange,
              ),
              child: FutureBuilder<User?>(
                future: FirebaseAuth.instance.currentUser != null
                    ? Future.value(FirebaseAuth.instance.currentUser)
                    : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(child: Text('Error loading user data'));
                  } else {
                    User user = snapshot.data!;
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                          },
                          child: user.photoURL != null
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(user.photoURL!),
                                  backgroundColor: Colors.white,
                                )
                              : const CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage('assets/images/default_avatar.jpg'), // Default avatar
                                ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Welcome, ${user.displayName ?? 'User'}!', // Display profile name
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Order History'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderHistoryPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.support),
              title: const Text('Support'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SupportPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  // Navigate to LoginPage after successful logout
                  Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }).catchError((error) {
                  // Handle any errors during sign-out
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Error signing out: $error'),
                  ));
                });
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Banner
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/banner.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(16),
                color: Colors.black.withOpacity(0.3),
                child: Text(
                  'Welcome, ${user.displayName ?? 'User'}!\nDelicious Food Delivered to You',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Categories Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    CategoryCard(
                      'Pizza',
                      'assets/images/pizza.jpg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantListPage(
                              category: 'Pizza',
                              restaurants: filterRestaurantsByCategory('Pizza'),
                            ),
                          ),
                        );
                      },
                    ),
                    CategoryCard(
                      'Burgers',
                      'assets/images/burger.jpg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantListPage(
                              category: 'Burgers',
                              restaurants: filterRestaurantsByCategory('Burgers'),
                            ),
                          ),
                        );
                      },
                    ),
                    CategoryCard(
                      'Sushi',
                      'assets/images/sushi.jpg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantListPage(
                              category: 'Sushi',
                              restaurants: filterRestaurantsByCategory('Sushi'),
                            ),
                          ),
                        );
                      },
                    ),
                    CategoryCard(
                      'Desserts',
                      'assets/images/desserts.jpg',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RestaurantListPage(
                              category: 'Desserts',
                              restaurants: filterRestaurantsByCategory('Desserts'),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Popular Restaurants Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Popular Restaurants',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...restaurants.map((restaurant) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantPage(
                        name: restaurant['name']!,
                        cuisine: restaurant['cuisine']!,
                        menu: List<Map<String, dynamic>>.from(restaurant['menu']),
                      ),
                    ),
                  );
                },
                child: RestaurantCard(
                  restaurant['name']!,
                  restaurant['cuisine']!,
                  restaurant['image']!,
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartPage()),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}