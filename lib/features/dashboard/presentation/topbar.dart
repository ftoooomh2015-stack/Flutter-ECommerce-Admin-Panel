import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TopBarWidget extends StatelessWidget {
  final String title;
  final double height;

  const TopBarWidget({
    super.key,
    required this.title,
    this.height = 72,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final userName = user?.displayName ?? 'مستخدم';
    final userEmail = user?.email ?? '';
    final avatar = user?.photoURL;

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white, // 👈 الخلفية البيضاء
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), // 👈 ظل خفيف
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // Title (يمين)
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const Spacer(),

          // User info (يسار)
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 10),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: ClipOval(
                  child: avatar != null && avatar.isNotEmpty
                      ? Image.network(
                    avatar,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Image.asset(
                        'assets/images/placeholder.jpg',
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    'assets/images/placeholder.jpg',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}