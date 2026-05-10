import 'package:flutter/material.dart';
import '../../models/product_model.dart';

class ProductRow extends StatelessWidget {
  final ProductModel product;

  const ProductRow({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.green;

    if (product.stock == 0) {
      statusColor = Colors.red;
    } else if (product.stock < 10) {
      statusColor = Colors.orange;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade100,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: product.imageUrl.isEmpty
                  ? _placeholder()
                  : Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;

                  return const Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => _placeholder(),
              ),
            ),
          ),

          // 📦 اسم المنتج
          Expanded(
            flex: 3,
            child: Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

      Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            if (product.description.isNotEmpty)
              Text(
                product.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        ),
          // 🏷 الفئة
          Expanded(
            flex: 2,
            child: Text(
              product.category,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 📊 المخزون
          Expanded(
            child: Text('${product.stock}'),
          ),

          // 💰 السعر
          Expanded(
            child: Text('${product.price.toStringAsFixed(2)} \$'),
          ),

          // 🚦 الحالة
          Expanded(
            child: Container(
              padding:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                product.status,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🧩 Placeholder
  Widget _placeholder() {
    return Image.asset(
      'assets/images/placeholder.png',
      fit: BoxFit.cover,
    );
  }
}