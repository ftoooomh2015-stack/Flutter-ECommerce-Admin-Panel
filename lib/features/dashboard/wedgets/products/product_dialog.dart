import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../services/firebase_storage_service.dart';
import '../../../../services/product_service.dart';

void addProduct(BuildContext context) {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController(); // كنترولر الوصف
  final priceController = TextEditingController();
  final stockController = TextEditingController();

  String category = 'العناية بالوجه';
  bool isLoading = false;

  File? imageFile;
  Uint8List? webImage;

  final categories = [
    'العناية بالوجه',
    'السيرومات',
    'منظفات البشرة',
    'العناية بالجسم',
    'العناية بالشعر',
    'العناية باليدين والأظافر',
    'العناية بالشفاه',
    'العناية بالقدمين',
    'واقي الشمس',
    'منتجات التقشير',
  ];

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: 650,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

                        // 🔷 عنوان
                        const Text(
                          'إضافة منتج جديد',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 🔷 اسم المنتج
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'اسم المنتج',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                          v == null || v.isEmpty ? 'أدخل الاسم' : null,
                        ),

                        const SizedBox(height: 10),

                        // 🔷 وصف المنتج
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'وصف المنتج',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // 🔷 السعر
                        TextFormField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'السعر',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // 🔷 المخزون
                        TextFormField(
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'المخزون',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // 🔷 الفئة
                        DropdownButtonFormField<String>(
                          value: category,
                          items: categories
                              .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c),
                          ))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => category = v);
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'الفئة',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // 🔷 اختيار الصورة
                        GestureDetector(
                          onTap: () async {
                            final result = await FirebaseStorageService.pickImage();
                            if (result == null) return;
                            webImage = result['webImage'];
                            imageFile = result['fileImage'];

                            setState(() {});
                          },
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: webImage != null
                                ? Image.memory(webImage!, fit: BoxFit.cover)
                                : imageFile != null
                                ? Image.file(imageFile!, fit: BoxFit.cover)
                                : const Center(
                              child: Text('اضغط لاختيار صورة'),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 🔷 الأزرار
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                if (!formKey.currentState!.validate()) return;

                                setState(() => isLoading = true);

                                try {
                                  String imageUrl = '';

                                  // 🔥 رفع الصورة (آمن)
                                  if (imageFile != null || webImage != null) {
                                    imageUrl =
                                    await FirebaseStorageService.uploadProductImage(
                                      file: imageFile,
                                      webFile: webImage,
                                    );
                                  }
                                  // 🔥 حفظ المنتج
                                  await ProductService.addProduct(
                                    name: nameController.text.trim(),
                                    description: descriptionController.text.trim(), // إضافة الوصف هنا
                                    price: double.tryParse(priceController.text.trim()) ?? 0,
                                    stock: int.tryParse(stockController.text.trim()) ?? 0,
                                    category: category,
                                    imageUrl: imageUrl,
                                  );
                                  if (context.mounted) {
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('تمت إضافة المنتج 🎉'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                  ProductService.fetchProducts();
                                } catch (e) {
                                  debugPrint("ERROR ADD PRODUCT: $e");

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('خطأ: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } finally {
                                  if (context.mounted) {
                                    setState(() => isLoading = false);
                                  }
                                }
                              },
                              child: isLoading
                                  ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text('حفظ', style: TextStyle(color: Colors.white),),
                            ),
                            const SizedBox(width: 10),

                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              child: const Text('إلغاء'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}