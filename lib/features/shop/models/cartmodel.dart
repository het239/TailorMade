import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItemModel {
  final String shopName; // Name of the shop
  final String style; // Style of the clothing item
  final String measurementType; // Type of measurement (e.g., HomeVisit, InStore)
  final String appointmentDate; // Appointment date
  final String appointmentTime; // Appointment time
  final Map<String, String> customizations; // Customizations for the item
  final String brand; // Selected brand
  final String size; // Selected size
  var quantity; // Quantity of the item
  RxDouble price = 0.0.obs; // Reactive price for dynamic updates

  CartItemModel({
    required this.shopName,
    required this.style,
    required this.measurementType,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.customizations,
    required this.brand, // Added brand
    required this.size, // Added size
    required this.quantity,
    double price = 0.0, // Default price
  }) {
    this.price.value = price; // Initialize reactive price
  }

  // Convert CartItemModel to JSON for saving to SharedPreferences
  Map<String, dynamic> toJson() => {
    'shopName': shopName,
    'style': style,
    'measurementType': measurementType,
    'appointmentDate': appointmentDate,
    'appointmentTime': appointmentTime,
    'customizations': customizations,
    'brand': brand, // Include brand in JSON
    'size': size, // Include size in JSON
    'quantity': quantity,
    'price': price.value, // Include reactive price in JSON
  };

  // Create CartItemModel from JSON saved in SharedPreferences
  static CartItemModel fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      shopName: json['shopName'],
      style: json['style'],
      measurementType: json['measurementType'],
      appointmentDate: json['appointmentDate'],
      appointmentTime: json['appointmentTime'],
      customizations: Map<String, String>.from(json['customizations']),
      brand: json['brand'] ?? '', // Parse brand from JSON
      size: json['size'] ?? '', // Parse size from JSON
      quantity: json['quantity'],
      price: json['price'] ?? 0.0, // Parse price from JSON
    );
  }
}