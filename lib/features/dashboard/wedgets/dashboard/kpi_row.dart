import 'package:flutter/material.dart';
import '../../../../../services/firebase_service.dart';
import '../../../../core/widgets/kpi_card.dart';

class KpiRow extends StatelessWidget {
  const KpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseService().getKpis(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data ?? {};

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              KpiCard(
                title: 'الإيرادات',
                value: '${data['revenue'] ?? 0} \$',
                color: Colors.green,
                icon: Icons.attach_money,
              ),
              const SizedBox(width: 12),

              KpiCard(
                title: 'الطلبات',
                value: '${data['orders'] ?? 0}',
                color: Colors.blue,
                icon: Icons.shopping_cart_outlined,
              ),
              const SizedBox(width: 12),

              KpiCard(
                title: 'المعلقة',
                value: '${data['قيد الانتظار'] ?? 0}',
                color: Colors.orange,
                icon: Icons.schedule,
              ),
              const SizedBox(width: 12),

              KpiCard(
                title: 'المنتجات',
                value: '${data['products'] ?? 0}',
                color: Colors.pink,
                icon: Icons.inventory_2_outlined,
              ),
            ],
          ),
        );
      },
    );
  }
}