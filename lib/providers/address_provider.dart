import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Address model class
class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  // Convert Address object to JSON (for saving to SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
    };
  }

  // Create Address object from JSON (for retrieving from SharedPreferences)
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
    );
  }
}

// Address Provider to manage address state and handle saving/loading from SharedPreferences
class AddressProvider with ChangeNotifier {
  Address? _address;

  Address? get address => _address;

  // Load saved address from SharedPreferences
  Future<void> loadAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? addressJson = prefs.getString('user_address');

    if (addressJson != null) {
      Map<String, dynamic> addressMap = jsonDecode(addressJson);
      _address = Address.fromJson(addressMap);
      notifyListeners();
    }
  }

  // Save address to SharedPreferences
  Future<void> saveAddress(Address address) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String addressJson = jsonEncode(address.toJson());
    await prefs.setString('user_address', addressJson);
    _address = address;
    notifyListeners();
  }

  // Clear the saved address (optional)
  Future<void> clearAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_address');
    _address = null;
    notifyListeners();
  }
}
