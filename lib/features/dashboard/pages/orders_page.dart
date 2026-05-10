import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import '../../../services/order_service.dart';
import '../../../services/product_service.dart';
import '../wedgets/orders/order_kpi_row.dart';
import '../wedgets/orders/orders_table.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override

  Future<void> exportOrdersToExcel() async {
    debugPrint('Exporting orders to Excel...');
    try {
      var excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      // 🔥 جلب الطلبات
      var data = await OrderService.getOrders();

      // 🔥 الهيدر (بالعربي)
      sheet.appendRow([
        TextCellValue('اسم العميل'),
        TextCellValue('التاريخ'),
        TextCellValue('عدد المنتجات'),
        TextCellValue('الإجمالي'),
        TextCellValue('الحالة'),
      ]);

      // 🔥 البيانات
      for (var order in data) {
        sheet.appendRow([
          TextCellValue(order.customer),
          TextCellValue(order.date.toString()),
          IntCellValue(order.totalItems),
          DoubleCellValue(double.tryParse(order.total.toString()) ?? 0),
          TextCellValue(order.status),
        ]);
      }

      // 🔥 تحويل لبايت
      final bytes = excel.encode();
      if (bytes == null) return;

      // 🔥 تحميل الملف (نفس طريقتك)
      ProductService.downloadFile(bytes, 'الطلبات.xlsx');

    } catch (e) {
      debugPrint("ERROR EXPORTING ORDERS: $e");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [

                  // 🔥 النص يأخذ كل المساحة
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'قائمة الطلبات',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'تابعي الطلبات، حدّثي حالتها، وراقبي عمليات المعالجة بكل سهولة ووضوح.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔥 الزر في النهاية (يمين في RTL)
                  SizedBox(
                    height: 40,
                    child: OutlinedButton.icon(
                      onPressed: exportOrdersToExcel,
                      icon: const Icon(Icons.file_download_outlined),
                      label: const Text('تصدير Excel'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 🔥 KPI
              const KpiOrderRow(),

              const SizedBox(height: 16),

              // 🔥 TABLE
              const Expanded(
                child: OrdersTable(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}