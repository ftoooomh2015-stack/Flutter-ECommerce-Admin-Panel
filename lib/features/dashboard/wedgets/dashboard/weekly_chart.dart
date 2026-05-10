import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyRevenueChart extends StatelessWidget {
  final List<double> revenue;
  final List<double> orders;

  const WeeklyRevenueChart({
    super.key,
    this.revenue = const [],
    this.orders = const [],
  });

  static const List<String> days = [
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد'
  ];

  List<double> _safe(List<double> data) {
    return List.generate(7, (i) => i < data.length ? data[i] : 0.0);
  }

  double _maxValue(List<double> a, List<double> b) {
    final all = [...a, ...b];
    if (all.isEmpty) return 100;
    return all.reduce(max);
  }

  @override
  Widget build(BuildContext context) {
    final safeRevenue = _safe(revenue);
    final safeOrders = _safe(orders);

    final maxY = _maxValue(safeRevenue, safeOrders);
    final safeMaxY = (maxY == 0 ? 10 : maxY * 1.2).toDouble();

    return Container(
      height: 420,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          // HEADER
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ملخص الإيرادات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'الأرباح الأسبوعية وحجم الطلبات',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // CHART
          Expanded(
            child: LineChart(
              _chartData(safeRevenue, safeOrders, safeMaxY),
            ),
          ),

          const SizedBox(height: 12),

          // LEGEND
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Legend(color: Colors.blue, label: 'الإيرادات'),
              SizedBox(width: 16),
              _Legend(color: Colors.pink, label: 'الطلبات'),
            ],
          ),
        ],
      ),
    );
  }

  LineChartData _chartData(
      List<double> revenue,
      List<double> orders,
      double maxY,
      ) {
    return LineChartData(
      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: maxY,

      gridData: const FlGridData(show: false),

      borderData: FlBorderData(show: false),

      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value % 1 != 0) return const SizedBox.shrink();

              final idx = value.toInt();
              if (idx < 0 || idx >= days.length) {
                return const SizedBox.shrink();
              }

              return Text(days[idx]);
            },
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),

      lineBarsData: [
        // Revenue
        LineChartBarData(
          spots: List.generate(
            7,
                (i) => FlSpot(i.toDouble(), revenue[i]),
          ),
          isCurved: true,
          color: Colors.blue,
          barWidth: 3,
          dotData: const FlDotData(show: false),
        ),

        // Orders
        LineChartBarData(
          spots: List.generate(
            7,
                (i) => FlSpot(i.toDouble(), orders[i]),
          ),
          isCurved: true,
          color: Colors.pink,
          barWidth: 2,
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 6),
        Text(label),
      ],
    );
  }
}