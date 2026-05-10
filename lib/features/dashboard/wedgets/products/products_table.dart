import 'package:flutter/material.dart';
import 'package:ownerapp/core/theme/app_theme.dart';
import '../../models/product_model.dart';
import '../../../../services/product_service.dart';

class ProductsTable extends StatefulWidget {
  const ProductsTable({super.key});

  @override
  State<ProductsTable> createState() => _ProductsTableState();
}

class _ProductsTableState extends State<ProductsTable> {
  int currentPage = 1;
  final int limit = 5;

  String? editingId;

  final TextEditingController priceEditController = TextEditingController();
  final TextEditingController stockEditController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 🔥 أول تحميل للبيانات
    ProductService.fetchProducts();
  }

  Future<void> updateProduct(String id) async {
    final price = double.tryParse(priceEditController.text) ?? 0;
    final stock = int.tryParse(stockEditController.text) ?? 0;

    await ProductService.updateProduct(
      id: id,
      price: price,
      stock: stock,
    );

    setState(() {
      editingId = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم تحديث المنتج'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> deleteProduct(String id) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف المنتج؟'),
        actionsAlignment: MainAxisAlignment.start,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ProductService.deleteProduct(id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف المنتج'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<ProductModel> getPageItems(List<ProductModel> allProducts) {
    final start = (currentPage - 1) * limit;
    final end = start + limit;

    if (start >= allProducts.length) return [];

    return allProducts.sublist(
      start,
      end > allProducts.length ? allProducts.length : end,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductModel>>(
      stream: ProductService.productsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final allProducts = snapshot.data!;
        final pageItems = getPageItems(allProducts);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: const Row(
                  children: [
                    Expanded(flex: 3, child: Text('المنتج')),
                    Expanded(flex: 3, child: Text('الوصف')),
                    Expanded(flex: 2, child: Text('الفئة')),
                    Expanded(flex: 2, child: Text('المخزون')),
                    Expanded(flex: 2, child: Text('السعر')),
                    Expanded(flex: 2, child: Text('تاريخ الإنشاء')),
                    SizedBox(width: 80),
                  ],
                ),
              ),

              const Divider(),

              // LIST
              Expanded(
                child: pageItems.isEmpty
                    ? const Center(child: Text('لا توجد منتجات'))
                    : ListView.builder(
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) {
                    final p = pageItems[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      child: Row(
                        children: [
                          // IMAGE + NAME
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: (p.imageUrl != null &&
                                        p.imageUrl!.isNotEmpty)
                                        ? Image.network(
                                      p.imageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.asset(
                                      'assets/images/placeholder.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    p.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            flex: 3,
                            child: Text(
                              p.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: Text(p.category),
                          ),

                          // STOCK
                          Expanded(
                            flex: 2,
                            child: editingId == p.id
                                ? TextField(
                              controller: stockEditController,
                            )
                                : GestureDetector(
                              onTap: () {
                                setState(() {
                                  editingId = p.id;
                                  stockEditController.text =
                                      p.stock.toString();
                                  priceEditController.text =
                                      p.price.toString();
                                });
                              },
                              child: Text('${p.stock}'),
                            ),
                          ),

                          // PRICE
                          Expanded(
                            flex: 2,
                            child: editingId == p.id
                                ? TextField(
                              controller: priceEditController,
                            )
                                : Text('${p.price} \$'),
                          ),

                          Expanded(
                            flex: 2,
                            child: Text(
                              "${p.createdAt.year}-${p.createdAt.month}-${p.createdAt.day}",
                            ),
                          ),

                          SizedBox(
                            width: 80,
                            child: Row(
                              children: [
                                if (editingId == p.id)
                                  IconButton(
                                    icon: const Icon(Icons.check,
                                        color: Colors.green),
                                    onPressed: () => updateProduct(p.id),
                                  ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => deleteProduct(p.id),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // PAGINATION
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text(
                      'عرض ${pageItems.length} من ${allProducts.length}',
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: currentPage > 1
                          ? () => setState(() => currentPage--)
                          : null,
                      child: const Text('السابق'),
                    ),
                    Text('$currentPage'),
                    TextButton(
                      onPressed: (currentPage * limit) < allProducts.length
                          ? () => setState(() => currentPage++)
                          : null,
                      child: const Text('التالي'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}