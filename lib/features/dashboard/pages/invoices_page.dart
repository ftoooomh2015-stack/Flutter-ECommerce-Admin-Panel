import 'package:flutter/material.dart';
import '../wedgets/invoices/invoice_kpi_row.dart';
import '../wedgets/invoices/invoices_table.dart';

class InvoicesPage extends StatelessWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الفواتير',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'إدارة الفواتير، متابعة المدفوعات، وتحديث حالة الدفع بسهولة.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // KPI
              const InvoiceKpiRow(),

              const SizedBox(height: 16),

              // TABLE
              Expanded(
                child: InvoicesTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}