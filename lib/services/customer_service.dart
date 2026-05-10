import 'package:cloud_firestore/cloud_firestore.dart';
import '../features/dashboard/models/customers_model.dart';

class CustomerService {
  static final _collection =
  FirebaseFirestore.instance.collection('customers');

  static Future<List<CustomerModel>> getCustomers() async {
    final snapshot = await _collection.get();

    return snapshot.docs
        .map((e) => CustomerModel.fromMap(e.data(), e.id))
        .toList();
  }

  static Future<void> deleteCustomer(String id) async {
    await _collection.doc(id).delete();
  }
}