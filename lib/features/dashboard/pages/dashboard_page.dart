import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../wedgets/dashboard/kpi_row.dart';
import '../wedgets/dashboard/recent_orders_card.dart';
import '../wedgets/dashboard/weekly_chart.dart';

class DashboardPage extends StatelessWidget {
  final Function(int)? onNavigate;

  const DashboardPage({super.key, this.onNavigate});

  // 🔥 جلب بيانات الأسبوع
  Future<Map<String, List<double>>> getWeeklyData() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('orders').get();

    List<double> revenue = List.filled(7, 0.0);
    List<double> orders = List.filled(7, 0.0);

    for (var doc in snapshot.docs) {
      final data = doc.data();

      final total = (data['total'] ?? 0).toDouble();
      final timestamp = data['acceptedAt'] as Timestamp?;

      if (timestamp == null) continue;

      final date = timestamp.toDate();
      final index = date.weekday - 1; // 0 = Monday

      if (index >= 0 && index < 7) {
        revenue[index] += total;
        orders[index] += 1;
      }
    }

    return {
      "revenue": revenue,
      "orders": orders,
    };
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أهلاً بعودتك! ${user?.displayName ?? ""}',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'متجرك يحقق أداءً مميزًا اليوم، استمري في التألق!',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),

                const SizedBox(height: 25),

                const KpiRow(),

                const SizedBox(height: 20),

                // 🔥 هنا التشارت الحقيقي من Firebase
                FutureBuilder<Map<String, List<double>>>(
                  future: getWeeklyData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final revenue = snapshot.data!["revenue"]!;
                    final orders = snapshot.data!["orders"]!;

                    return isWide
                        ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: WeeklyRevenueChart(
                            revenue: revenue,
                            orders: orders,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: RecentOrdersCard(
                            onOpenOrders: () {
                              onNavigate?.call(2);
                            },
                          ),
                        ),
                      ],
                    )
                        : WeeklyRevenueChart(
                      revenue: revenue,
                      orders: orders,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}