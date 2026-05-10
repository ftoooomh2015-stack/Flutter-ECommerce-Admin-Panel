import 'package:flutter/material.dart';
import '../wedgets/customers/customers_table.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'إدارة العلاقات',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'إدارة بيانات العملاء، متابعة الطلبات، ومعرفة النشاط الشرائي بسهولة.',
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: CustomersTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}