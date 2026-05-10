import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:ownerapp/services/product_service.dart';
import '../wedgets/products/product_dialog.dart';
import '../wedgets/products/products_kpi_row.dart';
import '../wedgets/products/products_table.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});
  // 🔥 2. دالة تصدير Excel (Placeholder الآن)
  Future<void> exportToExcel() async {
    debugPrint('Exporting products to Excel...');
    try{

      var excel = Excel.createExcel();
      Sheet sheet = excel['Sheet1'];

      var data = await ProductService.fetchProducts();

      // 🔥 الهيدر
      sheet.appendRow([
        TextCellValue('name'),
        TextCellValue('category'),
        TextCellValue('stock'),
        TextCellValue('price'),
        TextCellValue('status'),
        TextCellValue('createdAt'),
      ]);

      // 🔥 البيانات
      for (var product in data) {
        sheet.appendRow([
          TextCellValue(product.name),
          TextCellValue(product.category),
          IntCellValue(product.stock),
          DoubleCellValue(product.price),
          TextCellValue(product.status),
          TextCellValue(product.createdAt.toString()),
        ]);
      }

      // 🔥 حفظ الملف
      final bytes = excel.encode();
      if (bytes == null) return;

      ProductService.downloadFile(bytes, 'منتجاتي.xlsx');
    }catch(e)
    {
      print("ERROR EXPORTING TO EXCEL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 HEADER ROW
            Row(
              children: [
                // النص
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'كتالوج المنتجات',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'قومي بإدارة مجموعة العناية بالبشرة ومستويات المخزون الخاصة بك.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔥 أزرار التحكم
                Row(
                  children: [
                    // زر تصدير Excel
                    SizedBox(
                      height: 40,
                      child: OutlinedButton.icon(
                        onPressed: exportToExcel,
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

                    const SizedBox(width: 10),
                    SizedBox(
                      height: 40,
                      child:
                      // زر إضافة منتج
                      ElevatedButton.icon(
                        onPressed: () => addProduct(context),
                        icon: const Icon(Icons.add, color: Colors.white,),
                        label: const Text('إضافة منتج', style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF92C7FC),
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
              ],
            ),

            const SizedBox(height: 25),

            // KPI
            const ProductsKpiRow(),

            const SizedBox(height: 20),

            // Table
            const SizedBox(
              height: 500,
              child: ProductsTable(),
            ),
          ],
        ),
      ),
    );
  }
}