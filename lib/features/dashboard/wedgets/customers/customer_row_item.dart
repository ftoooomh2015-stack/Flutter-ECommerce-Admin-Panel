import 'package:flutter/material.dart';
import '../../../../services/customer_service.dart';
import '../../models/customers_model.dart';

class CustomerRow extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback onRefresh;

  const CustomerRow({
    super.key,
    required this.customer,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [

          // الاسم
          Expanded(flex: 3, child: Text(customer.name)),

          // الهاتف
          Expanded(flex: 2, child: Text(customer.phone)),

          // الإيميل
          Expanded(flex: 3, child: Text(customer.email)),

          // العنوان
          Expanded(flex: 2, child: Text(customer.address)),

          // عدد الطلبات
          Expanded(
            flex: 1,
            child: Text('${customer.totalOrders}'),
          ),

          // آخر طلب
          Expanded(
            flex: 2,
            child: Text(
              customer.lastOrderDate?.toString().split(' ')[0] ?? '-',
            ),
          ),

          // حذف
          SizedBox(
            width: 80,
            child: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await CustomerService.deleteCustomer(customer.id);
                onRefresh();
              },
            ),
          ),
        ],
      ),
    );
  }
}