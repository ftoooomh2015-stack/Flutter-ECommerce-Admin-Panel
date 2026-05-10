import 'package:flutter/material.dart';
import '../../../../services/order_service.dart';
import '../../models/order_model.dart';

class OrderRowItem extends StatefulWidget {
  final OrderModel order;
  final VoidCallback onRefresh;

  const OrderRowItem({
    super.key,
    required this.order,
    required this.onRefresh,
  });

  @override
  State<OrderRowItem> createState() => _OrderRowItemState();
}

class _OrderRowItemState extends State<OrderRowItem> {
  late String status;
  final orderService = OrderService();

  String customerName = "العميل";

  @override
  void initState() {
    super.initState();
    status = widget.order.status;
    _loadCustomerName();
  }

  Future<void> _loadCustomerName() async {
    print("USER ID: ${widget.order.customer}");
    final name =
    await orderService.getCustomerName(widget.order.customer);

    if (mounted) {
      setState(() {
        customerName = name;
      });
    }
  }

  double get totalAmount => widget.order.items.fold(
    0.0,
        (sum, item) => sum + (item.price * item.quantity),
  );

  Future<void> updateStatus(String newStatus) async {
    await OrderService.updateStatus(widget.order.id, newStatus);

    setState(() {
      status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // 👤 CUSTOMER NAME
          Expanded(
            flex: 3,
            child: Text(customerName),
          ),

          // 📅 DATE
          Expanded(
            flex: 2,
            child: Text(order.date.toString().split(" ").first),
          ),

          // 🔢 ITEMS
          Expanded(
            flex: 1,
            child: Text('${order.items.length}'),
          ),

          // 💰 TOTAL
          Expanded(
            flex: 2,
            child: Text(
              "${totalAmount.toStringAsFixed(2)}\$",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // 📌 STATUS
          Expanded(
            flex: 2,
            child: Text(
              status,
              style: TextStyle(
                color: status == 'مقبول'
                    ? Colors.green
                    : status == 'مرفوض'
                    ? Colors.red
                    : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 👁 ACTIONS
          Expanded(
            flex: 2,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility),
                  onPressed: () => _showOrderDetails(context),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle,
                      color: Colors.green),
                  onPressed: () async {
                    await OrderService.acceptOrder(
                      widget.order,
                    );

                    setState(() {
                      status = "مقبول";
                    });

                    widget.onRefresh();
                  },
                ),
                IconButton(
                  icon:
                  const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => updateStatus("مرفوض"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('طلب $customerName'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("الحالة: $status"),
              Text("الإجمالي: ${totalAmount.toStringAsFixed(2)} ر.س"),
              const Divider(),
              const Text(
                "المنتجات",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.order.items.length,
                  itemBuilder: (context, i) {
                    final item = widget.order.items[i];

                    return ListTile(
                      title: Text(item.productName),
                      subtitle: Text("الكمية: ${item.quantity}"),
                      trailing: Text(
                        "${(item.price * item.quantity).toStringAsFixed(2)} ر.س",
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}