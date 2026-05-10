import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/widgets/kpi_card.dart';

class InvoiceKpiRow extends StatelessWidget {
  const InvoiceKpiRow({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('invoices')
          .snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];

        int totalInvoices = docs.length;

        int paidInvoices = docs.where((e) {
          final data = e.data() as Map<String, dynamic>;

          return (data['paymentStatus'] ?? '')
              .toString()
              .trim() == 'مدفوع';
        }).length;

        int pendingInvoices = docs.where((e) {
          final data = e.data() as Map<String, dynamic>;

          return (data['paymentStatus'] ?? '')
              .toString()
              .trim() == 'لم يتم الدفع';
        }).length;

        double totalRevenue = docs.fold(0.0, (sum, e) {
          final data = e.data() as Map<String, dynamic>;

          final total = data['total'];

          if (total is int) {
            return sum + total.toDouble();
          }

          if (total is double) {
            return sum + total;
          }

          return sum;
        });

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // 🔵 إجمالي الفواتير
              KpiCard(
                title: 'إجمالي الفواتير',
                value: '$totalInvoices',
                color: Colors.blue,
                icon: Icons.receipt_long,
              ),

              const SizedBox(width: 12),

              // 🟢 المدفوعة
              KpiCard(
                title: 'مدفوعة',
                value: '$paidInvoices',
                color: Colors.green,
                icon: Icons.check_circle,
              ),

              const SizedBox(width: 12),

              // 🟠 المعلقة
              KpiCard(
                title: 'معلقة',
                value: '$pendingInvoices',
                color: Colors.orange,
                icon: Icons.hourglass_bottom,
              ),

              const SizedBox(width: 12),

              // 💰 الإيرادات
              KpiCard(
                title: 'الإيرادات',
                value: '\$${totalRevenue.toStringAsFixed(2)}',
                color: Colors.purple,
                icon: Icons.attach_money,
              ),
            ],
          ),
        );
      },
    );
  }
}