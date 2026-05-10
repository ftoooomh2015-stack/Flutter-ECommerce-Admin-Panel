import 'package:flutter/material.dart';
import 'package:ownerapp/features/dashboard/presentation/sidebar.dart';

import 'topbar.dart';
import '../pages/dashboard_page.dart';
import '../pages/products_page.dart';
import '../pages/orders_page.dart';
import '../pages/customers_page.dart';
import '../pages/invoices_page.dart';


class DashboardShell extends StatefulWidget {
  const DashboardShell({super.key});

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int index = 0;

  void changeTab(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  final pages = const [
    DashboardPage(),
    ProductsPage(),
    OrdersPage(),
    CustomersPage(),
    InvoicesPage(),
  ];

  final titles = const [
    'نظرة عامة على لوحة التحكم',
    'مخزون المنتجات',
    'إدارة الطلبات',
    'دليل العملاء',
    'الفواتير والمدفوعات',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar ثابت
          Sidebar(
            selectedIndex: index,
            onSelect: (i) {
              setState(() => index = i);
            },
          ),

          const SizedBox(width: 18),

          // Main Area
          Expanded(
            child: Column(
              children: [
                // 🔥 TopBar ثابت
                TopBarWidget(
                  title: titles[index],
                ),

                const SizedBox(height: 10),

                // Page Content
                Expanded(
                  child: pages[index] is DashboardPage
                      ? DashboardPage(onNavigate: changeTab)
                      : pages[index],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}