import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/kpi_card.dart';

class KpiOrderRow extends StatelessWidget {
  const KpiOrderRow({super.key});

  Stream<QuerySnapshot> _ordersStream() {
    return FirebaseFirestore.instance.collection('orders').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _ordersStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Row(
            children: [
              Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          );
        }

        final orders = snapshot.data!.docs;

        // 🔥 حساب الإحصائيات
        final total = orders.length;

        final pending = orders
            .where((e) => e['status'] == 'قيد الانتظار')
            .length;

        final completed = orders
            .where((e) => e['status'] == 'مقبول')
            .length;

        final cancelled = orders
            .where((e) => e['status'] == 'مرفوض')
            .length;

        return Row(
          children: [

            // 🔵 إجمالي الطلبات
            Expanded(
              child: KpiCard(
                title: 'إجمالي الطلبات',
                value: '$total',
                color: Colors.blue,
                icon: Icons.shopping_cart_outlined,
              ),
            ),

            const SizedBox(width: 12),

            // 🟠 قيد الانتظار
            Expanded(
              child: KpiCard(
                title: 'قيد الانتظار',
                value: '$pending',
                color: Colors.orange,
                icon: Icons.schedule,
              ),
            ),

            const SizedBox(width: 12),

            // 🟢 مكتملة
            Expanded(
              child: KpiCard(
                title: 'مكتملة',
                value: '$completed',
                color: Colors.green,
                icon: Icons.check_circle_outline,
              ),
            ),

            const SizedBox(width: 12),

            // 🔴 ملغية
            Expanded(
              child: KpiCard(
                title: 'ملغية',
                value: '$cancelled',
                color: Colors.red,
                icon: Icons.cancel_outlined,
              ),
            ),
          ],
        );
      },
    );
  }
}