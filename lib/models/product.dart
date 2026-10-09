class Product {
  final int id;
  final String name;
  final String category;
  final String price;
  final String image;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';

    if (json['thumbnail'] != null &&
        json['thumbnail'].toString().trim().isNotEmpty) {
      imageUrl = json['thumbnail'].toString();
    } else if (json['images'] != null &&
        json['images'] is List &&
        json['images'].isNotEmpty) {
      imageUrl = json['images'][0].toString();
    }

    return Product(
      id: json['id'] ?? 0,
      name: json['title'] ?? '',
      category: json['category'] ?? '',
      price: '\$${json['price']}',
      image: imageUrl,
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'category': category,
      'price': price.replaceAll('\$', ''),
      'thumbnail': image,
      'description': description,
    };
  }
}