import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/kpi_card.dart';

class ProductsKpiRow extends StatelessWidget {
  const ProductsKpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .snapshots(),
      builder: (context, snapshot) {
        int total = 0;
        int lowStock = 0;

        if (snapshot.hasData) {
          final docs = snapshot.data!.docs;

          total = docs.length;

          for (var d in docs) {
            final data = d.data() as Map<String, dynamic>;
            final stock = (data['stock'] ?? 0) as num;

            if (stock < 10) {
              lowStock++;
            }
          }
        }

        return Row(
          children: [
            KpiCard(
              title: 'إجمالي المنتجات',
              value: total.toString(),
              color: Colors.blue,
              icon: Icons.inventory,
            ),
            const SizedBox(width: 12),
            KpiCard(
              title: 'مخزون منخفض',
              value: lowStock.toString(),
              color: Colors.red,
              icon: Icons.warning,
            ),
          ],
        );
      },
    );
  }
}