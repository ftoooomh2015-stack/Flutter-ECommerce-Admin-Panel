import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../services/invoice_service.dart';
import '../../models/invoice_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoiceRowItem extends StatelessWidget {
  final InvoiceModel invoice;
  final VoidCallback onRefresh;

  const InvoiceRowItem({
    super.key,
    required this.invoice,
    required this.onRefresh,
  });

  Future<void> _downloadPdf() async {
    final pdf = pw.Document();
    final fontData = await rootBundle.load("assets/fonts/Cairo-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: ttf,
          bold: ttf, ),
        build: (context) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'فاتورة رقم: ${invoice.orderId}',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),
              pw.Text('العميل: ${invoice.customerName}'),
              pw.Text('الإجمالي: ${invoice.total} \$'),
              pw.Text('حالة الدفع: $statusText'),
              pw.Divider(),
              pw.Text(
                'المنتجات:',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              ...invoice.items.map((item) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(item.productName),
                      pw.Text('${item.quantity} x'),
                      pw.Text(
                        '${(item.price * item.quantity).toStringAsFixed(2)} \$',
                      ),
                    ],
                  ),
                );
              }),
              pw.Divider(),
              pw.Text(
                'التاريخ: ${invoice.createdAt.toDate().toString().split('.')[0]}',
              ),
            ],
          ),
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  String get statusText {
    if (invoice.paymentStatus == 'paid') return 'مدفوع';
    if (invoice.paymentStatus == 'pending') return 'لم يتم الدفع';
    if (invoice.paymentStatus == 'failed') return 'فشل';
    return invoice.paymentStatus;
  }

  Color get statusColor {
    if (invoice.paymentStatus == 'مدفوع') return Colors.green;
    if (invoice.paymentStatus == 'لم يتم الدفع') return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(invoice.customerName),
          ),

          Expanded(
            flex: 5,
            child: Text(invoice.orderId),
          ),

          Expanded(
            flex: 3,
            child: Text('${invoice.total}\$'),
          ),

          Expanded(
            flex: 2,
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: TextButton.icon(
              onPressed: _downloadPdf,
              icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
              label: const Text('PDF'),
            ),
          ),

          SizedBox(
            width: 120,
            child: Row(
              children: [

                IconButton(
                  icon: const Icon(Icons.check, color: Colors.green),
                  onPressed: () async {
                    await InvoiceService.updatePaymentStatus(
                      invoice.id,
                      'مدفوع',
                    );
                    onRefresh();
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () async {
                    await InvoiceService.updatePaymentStatus(
                      invoice.id,
                      'لم يتم الدفع',
                    );
                    onRefresh();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}