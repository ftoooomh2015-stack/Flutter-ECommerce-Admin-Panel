import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;
  final int totalOrders;
  final DateTime? lastOrderDate;
  final DateTime? createdAt;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.totalOrders,
    required this.lastOrderDate,
    required this.createdAt,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> data, String id) {
    return CustomerModel(
      id: id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      totalOrders: data['totalOrders'] ?? 0,
      lastOrderDate: (data['lastOrderDate'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'totalOrders': totalOrders,
      'lastOrderDate': lastOrderDate,
      'createdAt': createdAt,
    };
  }
}