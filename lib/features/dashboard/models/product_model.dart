import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final int stock;
  final double price;
  final String status;
  final String imageUrl;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.stock,
    required this.price,
    required this.status,
    required this.imageUrl,
    required this.createdAt,
  });

  // 🔥 من Firestore → Model
  factory ProductModel.fromFirestore(
      Map<String, dynamic> data,
      String id,
      ) {
    return ProductModel(
      id: id,
      imageUrl: data['imageUrl'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '', // تم جلب الوصف
      category: data['category'] ?? '',
      stock: data['stock'] ?? 0,
      price: (data['price'] ?? 0).toDouble(),
      status: data['status'] ?? 'متوفر',
      createdAt:
      (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // 🔥 من Model → Firestore
  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'description': description, // تم إضافة الوصف
      'category': category,
      'stock': stock,
      'price': price,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // 🔥 الحل هنا (copyWith)
  ProductModel copyWith({
    String? id,
    String? name,
    String? description, // إضافة الوصف
    String? category,
    int? stock,
    double? price,
    String? status,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description, // تحديث الوصف
      category: category ?? this.category,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}