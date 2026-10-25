import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_model.dart';

class InvoiceModel {
  final String id;
  final String orderId;
  final String customerName;
  final double total;
  final String paymentMethod; // cash_on_delivery
  final String paymentStatus; // pending / paid / failed

  final Timestamp createdAt;
  final List<OrderItem> items;

  InvoiceModel({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    required this.items,
  });

  factory InvoiceModel.fromMap(Map<String, dynamic> data, String id) {
    return InvoiceModel(
      id: id,
      orderId: data['orderId'] ?? '',
      customerName: data['customerName'] ?? '',
      total: (data['total'] ?? 0).toDouble(),

      paymentMethod: data['paymentMethod'] ?? 'cash_on_delivery',
      paymentStatus: data['paymentStatus'] ?? 'pending',

      createdAt: data['createdAt'] ?? Timestamp.now(),
      items: (data['items'] as List? ?? [])
          .map((e) => OrderItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'customerName': customerName,
      'total': total,

      'paymentMethod': 'cash_on_delivery',
      'paymentStatus': paymentStatus,

      'createdAt': createdAt,
      'items': items.map((e) => e.toMap()).toList(),
    };
  }
}