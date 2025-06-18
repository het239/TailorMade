import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cartmodel.dart';

class SessionController extends GetxController {
  var userId = ''.obs; // Unique identifier for the user
  var selectedStyle = ''.obs;
  var selectedShopName = ''.obs;
  var measurementType = ''.obs;
  var selectedBrand = ''.obs;
  var selectedSize = ''.obs;
  var appointmentDate = ''.obs;
  var appointmentTime = ''.obs;
  var customizations = <String, String>{}.obs;
  var quantity = 1.obs;
  var cartItems = <CartItemModel>[].obs;

  /// Set the current user's ID
  void setUserId(String id) {
    userId.value = id;
    loadSession(); // Load session data for the specific user
  }

  /// Save selected style
  void setSelectedStyle(String style) {
    selectedStyle.value = style;
    _saveToPrefs('selectedStyle', style);
    print("Selected Style: $style");
  }

  /// Save selected shop name
  void setSelectedShopName(String shopName) {
    selectedShopName.value = shopName;
    _saveToPrefs('selectedShopName', shopName);
    print("Selected Shop Name: $shopName");
  }

  /// Save measurement type
  void setMeasurementType(String type) {
    measurementType.value = type;
    _saveToPrefs('measurementType', type);
    print("Measurement Type: $type");
  }

  /// Save selected brand
  void setSelectedBrand(String brand) {
    selectedBrand.value = brand;
    _saveToPrefs('selectedBrand', brand);
    print("Selected Brand: $brand");
  }

  /// Save selected size
  void setSelectedSize(String size) {
    selectedSize.value = size;
    _saveToPrefs('selectedSize', size);
    print("Selected Size: $size");
  }

  /// Save appointment date
  void setAppointmentDate(DateTime date) {
    appointmentDate.value = date.toIso8601String();
    _saveToPrefs('appointmentDate', date.toIso8601String());
    print("Appointment Date: ${date.toIso8601String()}");
  }

  /// Save appointment time
  void setAppointmentTime(TimeOfDay time) {
    appointmentTime.value = time.format(Get.context!);
    _saveToPrefs('appointmentTime', time.format(Get.context!));
    print("Appointment Time: ${time.format(Get.context!)}");
  }

  /// Add customization
  void addCustomization(String key, String value) {
    customizations[key] = value;
    _saveToPrefs('customizations', customizations);
  }

  /// Increment item quantity
  void incrementQuantity(CartItemModel item) {
    final index = cartItems.indexWhere((element) => element == item);
    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh(); // Notify observers to rebuild
    }
    _saveCartItemsToPrefs();
  }

  /// Decrement item quantity
  void decrementQuantity(CartItemModel item) {
    final index = cartItems.indexWhere((element) => element == item);
    if (index != -1 && cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh(); // Notify observers to rebuild
    }
    _saveCartItemsToPrefs();
  }

  /// Add item to cart
  void addItemToCart(CartItemModel item) {
    cartItems.add(item);
    print("Item added: ${item.shopName}, total items: ${cartItems.length}");
    _saveCartItemsToPrefs();

    cartItems.refresh();
  }

  /// Remove item from cart
  void removeItemFromCart(CartItemModel item) {
    cartItems.remove(item);
    print("Item removed: ${item.shopName}, total items: ${cartItems.length}");
    _saveCartItemsToPrefs();
  }

  /// Clear session
  void clearSession() {
    selectedStyle.value = '';
    selectedShopName.value = '';
    measurementType.value = '';
    selectedBrand.value = '';
    selectedSize.value = '';
    appointmentDate.value = '';
    appointmentTime.value = '';
    customizations.clear();
    quantity.value = 1;
    cartItems.clear();
    _clearPrefs(); // Clear only the current user's preferences
  }

  /// Save data to SharedPreferences
  Future<void> _saveToPrefs(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    final userSpecificKey = '${key}_${userId.value}'; // Append userId to the key
    if (value is String) {
      await prefs.setString(userSpecificKey, value);
      print("Saved $userSpecificKey to prefs: $value");
    } else if (value is Map<String, String>) {
      await prefs.setString(userSpecificKey, json.encode(value));
      print("Saved $userSpecificKey to prefs: ${json.encode(value)}");
    }
  }

  /// Save cart items to SharedPreferences
  Future<void> _saveCartItemsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userSpecificKey = 'cartItems_${userId.value}'; // Append userId to the key
    final cartItemsJson = json.encode(cartItems.map((item) => item.toJson()).toList());
    print("Saving cart items: $cartItemsJson");
    await prefs.setString(userSpecificKey, cartItemsJson);
  }

  /// Load session data
  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userSpecificKeyPrefix = '_${userId.value}'; // Prefix for user-specific keys

    // Load user-specific preferences
    selectedStyle.value = prefs.getString('selectedStyle$userSpecificKeyPrefix') ?? '';
    selectedShopName.value = prefs.getString('selectedShopName$userSpecificKeyPrefix') ?? '';
    measurementType.value = prefs.getString('measurementType$userSpecificKeyPrefix') ?? '';
    selectedBrand.value = prefs.getString('selectedBrand$userSpecificKeyPrefix') ?? '';
    selectedSize.value = prefs.getString('selectedSize$userSpecificKeyPrefix') ?? '';
    appointmentDate.value = prefs.getString('appointmentDate$userSpecificKeyPrefix') ?? '';
    appointmentTime.value = prefs.getString('appointmentTime$userSpecificKeyPrefix') ?? '';
    customizations.value = prefs.getString('customizations$userSpecificKeyPrefix') != null
        ? Map<String, String>.from(json.decode(prefs.getString('customizations$userSpecificKeyPrefix')!))
        : {};

    // Load cart items for the specific user
    final cartItemsJson = prefs.getString('cartItems$userSpecificKeyPrefix');
    print("Loaded cart items JSON: $cartItemsJson");
    if (cartItemsJson != null) {
      final List<dynamic> cartItemsList = json.decode(cartItemsJson);
      cartItems.value = cartItemsList.map((itemJson) => CartItemModel.fromJson(itemJson)).toList();
    } else {
      cartItems.clear(); // Ensure no leftover data is present
    }
    print("Session loaded for user $userId, total items: ${cartItems.length}");
  }

  /// Clear all preferences for the user
  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final keysToClear = prefs.getKeys().where((key) => key.endsWith('_${userId.value}')).toList();
    for (final key in keysToClear) {
      await prefs.remove(key);
    }
    print("Cleared all preferences for user $userId");
  }
}