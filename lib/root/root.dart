import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/auth/pages/login_page.dart';
import '../features/dashboard/presentation/dashboard_shell.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          if (user != null) {
            return const DashboardShell();
          } else {
            return const LoginPage();
          }
        }

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}