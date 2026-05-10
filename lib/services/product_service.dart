import 'dart:typed_data';
import 'dart:async'; // 🔥 جديد
import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/dashboard/models/product_model.dart';
import 'dart:html' as html;

class ProductService {
  static final _db = FirebaseFirestore.instance;

  static final StreamController<List<ProductModel>> _productsController =
  StreamController<List<ProductModel>>.broadcast();

  static Stream<List<ProductModel>> get productsStream =>
      _productsController.stream;

  /// 🔹 إضافة منتج
  static Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required int stock,
    required String category,
    required String imageUrl,
  }) async {
    await _db.collection('products').add({
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'status': 'In Stock',
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await fetchProducts(); // 🔥 يحدث الستريم تلقائي
  }

  /// 🔹 تعديل منتج
  static Future<void> updateProduct({
    required String id,
    required double price,
    required int stock,
  }) async {
    await _db.collection('products').doc(id).update({
      'price': price,
      'stock': stock,
    });

    await fetchProducts(); // 🔥 تحديث
  }

  /// 🔹 حذف منتج
  static Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();

    await fetchProducts(); // 🔥 تحديث
  }

  /// 🔹 جلب المنتجات + بثها
  static Future<List<ProductModel>> fetchProducts() async {
    final snapshot = await _db
        .collection('products')
        .orderBy('createdAt', descending: true)
        .get();

    final data = snapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
        .toList();

    _productsController.add(data); // 🔥 بث البيانات

    return data;
  }

  /// 🔹 تحميل ملف
  static void downloadFile(List<int> bytes, String fileName) {
    final uint8 = Uint8List.fromList(bytes);

    final blob = html.Blob([uint8]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", fileName)
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}