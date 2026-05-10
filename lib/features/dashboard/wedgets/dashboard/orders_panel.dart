import 'package:flutter/material.dart';
import '../../../../../../services/firebase_service.dart';
import 'status_pill.dart';

class OrdersPanel extends StatelessWidget {
  OrdersPanel({super.key});

  final service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: service.getOrders(),
      builder: (context, snapshot) {
        final orders = snapshot.data ?? [];

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: _box(),
          child: Column(
            children: [
              const Text('أحدث الطلبات'),

              const SizedBox(height: 12),

              ...orders.map((o) => ListTile(
                title: Text(o['name']),
                subtitle: Text(o['item']),
                trailing: Column(
                  children: [
                    Text(o['price']),
                    StatusPill(text: o['status']),
                  ],
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  );
}