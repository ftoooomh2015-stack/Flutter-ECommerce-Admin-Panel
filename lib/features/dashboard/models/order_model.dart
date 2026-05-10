import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['id'] ?? '',
      productName: map['name'] ?? '',
      price: (map['total_price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': productId,
      'name': productName,
      'total_price': price,
      'quantity': quantity,
    };
  }
}

class OrderModel {
  final String id;
  final String customer;
  final DateTime date;
  final List<OrderItem> items;
  final double total;
  final String status;

  OrderModel({
    required this.id,
    required this.customer,
    required this.date,
    required this.items,
    required this.total,
    required this.status,
  });

  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);

  factory OrderModel.fromMap(
      Map<String, dynamic> data,
      String id,
      ) {
    var list = data['items'] as List? ?? [];

    return OrderModel(
      id: id,

      // لأنك ما تحفظين customer
      customer: data['userId'] ?? 'عميل',

      // لأنك تحفظين timestamp كنص
      date: DateTime.tryParse(
        data['timestamp'] ?? '',
      ) ??
          DateTime.now(),

      items: list
          .map(
            (i) => OrderItem.fromMap(
          Map<String, dynamic>.from(i),
        ),
      )
          .toList(),

      total: (data['totalPrice'] ?? 0).toDouble(),

      status: data['status'] ?? 'قيد الانتظار',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': customer,
      'timestamp': date.toIso8601String(),
      'items': items.map((i) => i.toMap()).toList(),
      'totalPrice': total,
      'status': status,
    };
  }
}