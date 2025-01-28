// lib/services/shared_preferences_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/address_provider.dart'; // Assuming Address model is in models/

class SharedPreferencesService {
  // Save address to SharedPreferences
  static Future<void> saveAddress(Address address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String addressJson = jsonEncode(address.toJson());
    await prefs.setString('user_address', addressJson);
  }

  // Load saved address from SharedPreferences
  static Future<Address?> loadAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? addressJson = prefs.getString('user_address');
    if (addressJson != null) {
      Map<String, dynamic> addressMap = jsonDecode(addressJson);
      return Address.fromJson(addressMap);
    }
    return null; // No address saved
  }

  // Update an existing address in SharedPreferences
  static Future<void> updateAddress(Address address) async {
    await saveAddress(address);  // Reusing saveAddress method to update
  }

  // Remove the saved address from SharedPreferences
  static Future<void> removeAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_address');
  }

  // Save other preferences, like user settings or login state
  static Future<void> saveLoginState(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
  }

  static Future<bool> loadLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false; // Default to false if not found
  }

  // Save user's theme preference (dark/light mode)
  static Future<void> saveThemePreference(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDarkMode);
  }

  // Load user's theme preference
  static Future<bool> loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_dark_mode') ?? false; // Default to false if not found
  }

  // Clear all stored preferences (use with caution)
  static Future<void> clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all data
  }
}
