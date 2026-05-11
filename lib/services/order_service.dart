import 'package:cloud_firestore/cloud_firestore.dart';

import '../features/dashboard/models/order_model.dart';
import '../features/dashboard/models/invoice_model.dart';
import 'invoice_service.dart';

class OrderService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final CollectionReference _orders = _db.collection('orders');
  static final CollectionReference _products = _db.collection('products');

  // 🔥 جلب الطلبات
  static Future<List<OrderModel>> getOrders() async {
    final snapshot =
    await _orders.orderBy('timestamp', descending: true).get();

    return snapshot.docs
        .map((e) => OrderModel.fromMap(
      e.data() as Map<String, dynamic>,
      e.id,
    ))
        .toList();
  }

  // 🔥 إضافة طلب
  static Future<void> addOrder(OrderModel order) async {
    await _orders.add(order.toMap());
  }

  // 🔥 تحديث حالة الطلب فقط
  static Future<void> updateStatus(String id, String status) async {
    await _orders.doc(id).update({'status': status});
  }

  // 🔥 تحديث كامل الطلب
  static Future<void> updateOrder(String id, OrderModel order) async {
    await _orders.doc(id).update(order.toMap());
  }

  // 🔥 حذف طلب
  static Future<void> deleteOrder(String id) async {
    await _orders.doc(id).delete();
  }

  // ======================================================
  // 🔥 ACCEPT ORDER + STOCK + INVOICE (CORE LOGIC)
  // ======================================================
  static Future<void> acceptOrder(OrderModel order) async {
    final orderRef = _orders.doc(order.id);

    WriteBatch batch = _db.batch();

    double total = 0;

    // 🔥 1. خصم المخزون + حساب الإجمالي
    for (var item in order.items) {
      final productRef = _products.doc(item.productId);

      final productSnap = await productRef.get();
      if (!productSnap.exists) continue;

      final data = productSnap.data() as Map<String, dynamic>;
      final currentStock = (data['stock'] ?? 0) as int;

      final newStock = currentStock - item.quantity;

      batch.update(productRef, {
        'stock': newStock < 0 ? 0 : newStock,
      });

      total += item.price * item.quantity;
    }

    // 🔥 2. تحديث الطلب
    batch.update(orderRef, {
      'status': 'مقبول',
      'acceptedAt': Timestamp.now(),
    });

    await batch.commit();

    // 🔥 3. جلب اسم العميل الحقيقي (إذا order.customer = uid)
    String customerName = order.customer;

    final userSnap = await FirebaseFirestore.instance
        .collection('customers')
        .doc(order.customer)
        .get();

    if (userSnap.exists) {
      customerName = userSnap.data()?['name'] ?? order.customer;
    }

    // 🔥 4. إنشاء الفاتورة
    final invoice = InvoiceModel(
      id: '',
      orderId: order.id,
      customerName: customerName,
      total: total, // 🔥 محسوب فعليًا
      paymentMethod: 'عند الإستلام',
      paymentStatus: 'لم يتم الدفع',
      createdAt: Timestamp.now(),
      items: order.items,
    );

    await InvoiceService.createInvoice(invoice);
  }

  Future<String> getCustomerName(String userId) async {
    final doc = await FirebaseFirestore.instance
        .collection('customers')
        .doc(userId)
        .get();

    if (doc.exists) {
      return doc.data()?['name'] ?? 'عميل';
    }

    return 'عميل';
  }
}