class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'],
      price: double.parse(json['price'].toString()),
      quantity: json['quantity'],
      subtotal: double.parse(json['subtotal'].toString()),
    );
  }
}

class Order {
  final int id;
  final double total;
  final String status;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsData = json['items'] as List<dynamic>? ?? [];

    return Order(
      id: json['id'],
      total: double.parse(json['total'].toString()),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      items: itemsData
          .map(
            (item) => OrderItem.fromJson(item),
          )
          .toList(),
    );
  }
}