class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  final String description;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      stock: json['stock'] ?? 0,
    );
  }
}