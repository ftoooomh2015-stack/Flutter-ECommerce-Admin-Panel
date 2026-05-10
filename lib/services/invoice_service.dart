import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/dashboard/models/invoice_model.dart';

class InvoiceService {
  static final _collection =
  FirebaseFirestore.instance.collection('invoices');

  static Future<List<InvoiceModel>> getInvoices() async {
    final snapshot = await _collection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((e) => InvoiceModel.fromMap(e.data(), e.id))
        .toList();
  }

  static Future<void> createInvoice(InvoiceModel invoice) async {
    await _collection.add(invoice.toMap());
  }

  static Future<void> updatePaymentStatus(String id, String status) async {
    await _collection.doc(id).update({
      'paymentStatus': status,
    });
  }
}