import 'package:flutter/material.dart';
import '../../../../services/customer_service.dart';
import '../../models/customers_model.dart';
import 'customer_row_item.dart';

class CustomersTable extends StatefulWidget {
  const CustomersTable({super.key});

  @override
  State<CustomersTable> createState() => _CustomersTableState();
}

class _CustomersTableState extends State<CustomersTable> {
  List<CustomerModel> customers = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    customers = await CustomerService.getCustomers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [

          // HEADER
          Container(
            padding: const EdgeInsets.all(14),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('الاسم')),
                Expanded(flex: 2, child: Text('الهاتف')),
                Expanded(flex: 3, child: Text('الإيميل')),
                Expanded(flex: 2, child: Text('العنوان')),
                Expanded(flex: 1, child: Text('الطلبات')),
                Expanded(flex: 2, child: Text('آخر طلب')),
                SizedBox(width: 80),
              ],
            ),
          ),

          const Divider(),

          // LIST
          Expanded(
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, i) {
                return CustomerRow(
                  customer: customers[i],
                  onRefresh: load,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}