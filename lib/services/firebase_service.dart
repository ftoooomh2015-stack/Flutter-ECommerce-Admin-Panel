import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;

  // Orders
  Stream<List<Map<String, dynamic>>> getOrders() {
    return _db.collection('orders').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
    );
  }

  // KPIs
  Future<Map<String, dynamic>> getKpis() async {
    try {
      final ordersSnap = await _db.collection('orders').get();
      final productsSnap = await _db.collection('products').get();
      final invoicesSnap = await _db.collection('invoices').get();

      final orders = ordersSnap.docs;
      final products = productsSnap.docs;
      final invoices = invoicesSnap.docs;

      double revenue = 0;
      int pending = 0;

      // ✅ الإيرادات من الفواتير (الصحيح)
      for (var doc in invoices) {
        final data = doc.data();
        revenue += (data['total'] ?? 0).toDouble();
      }

      // ✅ الطلبات المعلقة
      for (var doc in orders) {
        final data = doc.data();

        if (data['status'] == 'pending') {
          pending++;
        }
      }

      return {
        'revenue': revenue,
        'orders': orders.length,
        'pending': pending,
        'products': products.length,
      };
    } catch (e) {
      return {
        'revenue': 0,
        'orders': 0,
        'pending': 0,
        'products': 0,
      };
    }
  }

  Future<Map<String, List<double>>> getWeeklyStats() async {
    final snapshot = await FirebaseFirestore.instance.collection('invoices').get();

    List<double> revenue = List.filled(7, 0);
    List<double> orders = List.filled(7, 0);

    final now = DateTime.now();

    for (var doc in snapshot.docs) {
      final data = doc.data();

      final total = (data['total'] ?? 0).toDouble();

      final timestamp = data['createdAt'];
      if (timestamp == null) continue;

      final date = (timestamp as Timestamp).toDate();

      final diff = now.difference(date).inDays;

      if (diff >= 0 && diff < 7) {
        int index = 6 - diff;

        revenue[index] += total;
        orders[index] += 1;
      }
    }

    return {
      'revenue': revenue,
      'orders': orders,
    };
  }
}