import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  int get itemCount => _items.length;

  WishlistProvider() {
    loadWishlist();
  }

  bool isInWishlist(Product product) {
    return _items.any((item) => item.id == product.id);
  }

  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();

    final savedWishlist = prefs.getStringList('wishlist') ?? [];

    _items.clear();

    for (var productString in savedWishlist) {
      final Map<String, dynamic> productMap = jsonDecode(productString);
      _items.add(Product.fromJson(productMap));
    }

    notifyListeners();
  }

  Future<void> saveWishlist() async {
    final prefs = await SharedPreferences.getInstance();

    final savedWishlist = _items.map((product) {
      return jsonEncode(product.toJson());
    }).toList();

    await prefs.setStringList('wishlist', savedWishlist);
  }

  Future<void> addToWishlist(Product product) async {
    if (!isInWishlist(product)) {
      _items.add(product);
      await saveWishlist();
      notifyListeners();
    }
  }

  Future<void> removeFromWishlist(Product product) async {
    _items.removeWhere((item) => item.id == product.id);

    await saveWishlist();
    notifyListeners();
  }

  Future<void> toggleWishlist(Product product) async {
    if (isInWishlist(product)) {
      await removeFromWishlist(product);
    } else {
      await addToWishlist(product);
    }
  }

  Future<void> clearWishlist() async {
    _items.clear();
    await saveWishlist();
    notifyListeners();
  }
}