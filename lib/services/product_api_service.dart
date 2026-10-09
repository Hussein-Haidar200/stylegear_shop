import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductApiService {
  static Future<List<Product>> fetchSportProducts() async {
    final List<String> categories = [
      'mens-shirts',
      'mens-shoes',
      'womens-shoes',
      'tops',
      'womens-dresses',
      'sunglasses',
    ];

    List<Product> allProducts = [];

    for (String category in categories) {
      final url = Uri.parse(
        'https://dummyjson.com/products/category/$category',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final productsJson = data['products'] as List;

        allProducts.addAll(
          productsJson.map((item) {
            return Product.fromJson(item);
          }).toList(),
        );
      }
    }

    final Map<int, Product> uniqueProducts = {};

    for (Product product in allProducts) {
      uniqueProducts[product.id] = product;
    }

    return uniqueProducts.values.take(20).toList();
  }
}