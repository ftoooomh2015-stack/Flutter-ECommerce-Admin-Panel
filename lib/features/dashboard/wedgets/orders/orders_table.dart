import 'package:flutter/material.dart';
import '../../../../services/order_service.dart';
import '../../models/order_model.dart';
import 'order_row_item.dart';

class OrdersTable extends StatefulWidget {
  const OrdersTable({super.key});

  @override
  State<OrdersTable> createState() => _OrdersTableState();
}

class _OrdersTableState extends State<OrdersTable> {
  List<OrderModel> orders = [];

  int currentPage = 1;
  final int limit = 5;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    orders = await OrderService.getOrders();
    setState(() {});
  }

  List<OrderModel> get pageItems {
    final start = (currentPage - 1) * limit;
    final end = start + limit;

    if (start >= orders.length) return [];

    return orders.sublist(
      start,
      end > orders.length ? orders.length : end,
    );
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: const Row(
              children: [
                Expanded(flex: 4, child: Text('العميل')),
                Expanded(flex: 3, child: Text('التاريخ')),
                Expanded(flex: 2, child: Text('العدد')),
                Expanded(flex: 2, child: Text('الإجمالي')),
                Expanded(flex: 2, child: Text('الحالة')),
                Expanded(flex: 2, child: Text('عرض الطلب')),
                SizedBox(width: 100),
              ],
            ),
          ),

          const Divider(),

          // LIST
          Expanded(
            child: ListView.builder(
              itemCount: pageItems.length,
              itemBuilder: (context, i) {
                return OrderRowItem(
                  order: pageItems[i],
                  onRefresh: load,
                );
              },
            ),
          ),

          // PAGINATION
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [

                Text(
                  'عرض ${pageItems.length} من ${orders.length}',
                  style: TextStyle(color: Colors.grey[600]),
                ),

                const Spacer(),

                // 🔙 السابق
                TextButton(
                  onPressed: currentPage > 1
                      ? () => setState(() => currentPage--)
                      : null,
                  child: const Text('السابق'),
                ),

                const SizedBox(width: 8),

                // رقم الصفحة
                Text(
                  '$currentPage',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(width: 8),

                // ➜ التالي
                TextButton(
                  onPressed: (currentPage * limit) < orders.length
                      ? () => setState(() => currentPage++)
                      : null,
                  child: const Text('التالي'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}