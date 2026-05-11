import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecentOrdersCard extends StatefulWidget {
  final VoidCallback? onOpenOrders;

  const RecentOrdersCard({
    super.key,
    this.onOpenOrders,
  });

  @override
  State<RecentOrdersCard> createState() => _RecentOrdersCardState();
}

class _RecentOrdersCardState extends State<RecentOrdersCard> {
  final Map<String, String> _namesCache = {};
  final Map<String, bool> _loadingUsers = {};

  String getCustomerName(String userId) {
    return _namesCache[userId] ?? 'العميل';
  }

  Future<void> _loadCustomerName(String userId) async {
    if (_loadingUsers[userId] == true) return;

    _loadingUsers[userId] = true;

    try {
      print("USER ID: $userId");

      final doc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .get();

      final name = doc.data()?['name'] ?? 'عميل';
      print("NAME: $name");
      _namesCache[userId] = name;
    } catch (e) {
      _namesCache[userId] = 'عميل';
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .orderBy('acceptedAt', descending: true)
              .limit(7)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('حدث خطأ');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? [];

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'أحدث الطلبات',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'آخر الطلبات من المتجر',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(),

                if (docs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.shopping_bag_outlined,
                            size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          'لا توجد طلبات',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final data =
                      docs[index].data() as Map<String, dynamic>;

                      final userId = data['userId'];

                      if (!_namesCache.containsKey(userId)) {
                        _loadCustomerName(userId);
                      }

                      final name = getCustomerName(userId);

                      final total = data['totalPrice'] ?? 0;

                      final totalValue = total is int
                          ? total.toDouble()
                          : double.tryParse(total.toString()) ?? 0.0;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.shopping_bag_outlined),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'طلب جديد',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "\$${totalValue.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 10),
                            _Status(status: data['status'] ?? 'معلق'),
                          ],
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: widget.onOpenOrders,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'عرض جميع الطلبات',
                          style: TextStyle(color: Colors.black54),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.turn_slight_right_rounded,
                          color: Colors.black54,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Status extends StatelessWidget {
  final String status;

  const _Status({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.orange.shade50;
    Color color = Colors.orange;

    if (status == 'تم القبول') {
      bg = Colors.green.shade50;
      color = Colors.green;
    } else if (status == 'ملغى') {
      bg = Colors.red.shade50;
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12),
      ),
    );
  }
}