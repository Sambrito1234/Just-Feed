import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final double? latitude;
  final double? longitude;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class AddressProvider extends ChangeNotifier {
  Address? _address;

  Address? get address => _address;

  Future<void> saveAddress(Address address) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('address', jsonEncode(address.toJson()));
    _address = address;
    notifyListeners();
  }

  Future<void> loadAddress() async {
    final prefs = await SharedPreferences.getInstance();
    String? addressJson = prefs.getString('address');
    if (addressJson != null) {
      _address = Address.fromJson(jsonDecode(addressJson));
      notifyListeners();
    }
  }

  Future<void> clearAddress() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('address');
    _address = null;
    notifyListeners();
  }

  Future<void> updateCoordinates(double latitude, double longitude) async {
    if (_address != null) {
      _address = Address(
        street: _address!.street,
        city: _address!.city,
        state: _address!.state,
        zipCode: _address!.zipCode,
        country: _address!.country,
        latitude: latitude,
        longitude: longitude,
      );
      await saveAddress(_address!);
    }
  }
}
