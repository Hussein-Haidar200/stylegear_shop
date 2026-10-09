import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice {
    double total = 0;

    for (var item in _items) {
      String cleanPrice = item.product.price.replaceAll('\$', '');
      double price = double.tryParse(cleanPrice) ?? 0;
      total += price * item.quantity;
    }

    return total;
  }

  bool contains(Product product) {
    return _items.any(
          (item) =>
      item.product.name == product.name &&
          item.product.category == product.category &&
          item.product.price == product.price,
    );
  }

  void addToCart(Product product) {
    for (var item in _items) {
      if (item.product.name == product.name &&
          item.product.category == product.category &&
          item.product.price == product.price) {
        item.quantity++;
        notifyListeners();
        return;
      }
    }

    _items.add(
      CartItem(
        product: product,
        quantity: 1,
      ),
    );

    notifyListeners();
  }

  void increaseQuantity(Product product) {
    for (var item in _items) {
      if (item.product.name == product.name &&
          item.product.category == product.category &&
          item.product.price == product.price) {
        item.quantity++;
        notifyListeners();
        return;
      }
    }
  }

  void decreaseQuantity(Product product) {
    for (var item in _items) {
      if (item.product.name == product.name &&
          item.product.category == product.category &&
          item.product.price == product.price) {
        if (item.quantity > 1) {
          item.quantity--;
        } else {
          _items.remove(item);
        }

        notifyListeners();
        return;
      }
    }
  }

  void removeFromCart(Product product) {
    _items.removeWhere(
          (item) =>
      item.product.name == product.name &&
          item.product.category == product.category &&
          item.product.price == product.price,
    );

    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}