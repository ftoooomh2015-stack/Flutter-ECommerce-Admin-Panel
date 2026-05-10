import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onSelect;
  final int selectedIndex;

  const Sidebar({
    super.key,
    required this.onSelect,
    required this.selectedIndex,
  });

  final List<_SideItem> items = const [
    _SideItem(icon: Icons.grid_view, label: 'لوحة التحكم'),
    _SideItem(icon: Icons.inventory_2_outlined, label: 'المنتجات'),
    _SideItem(icon: Icons.receipt_long, label: 'الطلبات'),
    _SideItem(icon: Icons.people_outline, label: 'العملاء'),
    _SideItem(icon: Icons.document_scanner, label: 'الفواتير'),
  ];

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          ClipOval(
            child: Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 25),

          // Menu
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selectedIndex == index;

                return _SidebarItemWidget(
                  icon: item.icon,
                  label: item.label,
                  isSelected: isSelected,
                  onTap: () => onSelect(index),
                );
              },
            ),
          ),
          const Divider(),

          _BottomItem(
            icon: Icons.logout,
            label: 'تسجيل الخروج',
            onTap: _signOut,
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

/* ---------------- MODEL ---------------- */
class _SideItem {
  final IconData icon;
  final String label;

  const _SideItem({required this.icon, required this.label});
}

/* ---------------- ITEM ---------------- */
class _SidebarItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItemWidget({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isSelected ? const Color(0xFFEAF3FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : Colors.grey[700],
                ),

                const SizedBox(width: 12),

                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppTheme.primaryColor
                        : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ---------------- BOTTOM ---------------- */
class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.black54),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}