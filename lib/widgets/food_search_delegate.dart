import 'package:flutter/material.dart';
import '../screen/RestaurantPage.dart';

class FoodSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> restaurants;

  FoodSearchDelegate({required this.restaurants});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = restaurants
        .where((restaurant) =>
            restaurant['name']!.toLowerCase().contains(query.toLowerCase()) ||
            restaurant['cuisine']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No results found for "$query"',
          style: const TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final restaurant = results[index];
        return ListTile(
          leading: Image.asset(
            restaurant['image']!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(restaurant['name']!),
          subtitle: Text(restaurant['cuisine']!),
          onTap: () {
            close(context, restaurant);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RestaurantPage(
                  name: restaurant['name']!,
                  cuisine: restaurant['cuisine']!,
                  menu: (restaurant['menu']),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = restaurants
        .where((restaurant) =>
            restaurant['name']!.toLowerCase().contains(query.toLowerCase()) ||
            restaurant['cuisine']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final restaurant = suggestions[index];
        return ListTile(
          leading: Image.asset(
            restaurant['image']!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(restaurant['name']!),
          subtitle: Text(restaurant['cuisine']!),
          onTap: () {
            query = restaurant['name']!;
            showResults(context);
          },
        );
      },
    );
  }
}
