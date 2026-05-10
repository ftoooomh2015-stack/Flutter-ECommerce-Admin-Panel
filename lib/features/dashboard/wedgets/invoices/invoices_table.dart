import 'package:flutter/material.dart';
import '../../../../services/invoice_service.dart';
import '../../models/invoice_model.dart';
import 'invoice_row_item.dart';

class InvoicesTable extends StatefulWidget {
  const InvoicesTable({super.key});

  @override
  State<InvoicesTable> createState() => _InvoicesTableState();
}

class _InvoicesTableState extends State<InvoicesTable> {
  List<InvoiceModel> invoices = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    invoices = await InvoiceService.getInvoices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(14),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('العميل')),
                Expanded(flex: 2, child: Text('رقم الطلب')),
                Expanded(flex: 2, child: Text('الإجمالي')),
                Expanded(flex: 2, child: Text('الحالة')),
                SizedBox(width: 120),
              ],
            ),
          ),

          const Divider(),

          Expanded(
            child: ListView.builder(
              itemCount: invoices.length,
              itemBuilder: (context, i) {
                return InvoiceRowItem(
                  invoice: invoices[i],
                  onRefresh: load,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}