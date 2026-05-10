import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ownerapp/core/theme/app_theme.dart';
import '../../../services/auth_services.dart';
import '../widgets/left_illustration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  bool _loading = false;
  String? _errorText;

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      final user = await AuthService.signIn(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      if (user != null && mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorText = e.message ?? 'Login failed';
      });
    } catch (e) {
      setState(() {
        _errorText = 'حدث خطأ غير متوقع';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      final user = await AuthService.signInWithGoogle();
      if (user != null) {
        if (_emailCtrl.text.isNotEmpty && _passwordCtrl.text.isNotEmpty) {
          try {
            await AuthService.linkEmailPassword(
              user: user,
              email: _emailCtrl.text.trim(),
              password: _passwordCtrl.text,
            );
          } catch (e) {
            debugPrint("فشل الربط: $e");
          }
        }
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      }
    } catch (e) {
      setState(() {
        _errorText = "فشل تسجيل الدخول بجوجل";
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }


  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final isWide = width >= 1000;
    final useScroll = height < 700;

    Widget content = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: isWide
              ? Row(
            children: [
              Expanded(child: _buildForm()),
              const SizedBox(width: 40),
              const Expanded(child: LeftIllustration()),
            ],
          )
              : _buildForm(),
        ),
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: useScroll
            ? SingleChildScrollView(
          child: SizedBox(
            height: height,
            child: content,
          ),
        )
            : content,
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 18),
        Card(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'مرحبًا بعودتك!',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'سجّل الدخول للوصول إلى لوحة التحكم',
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 35),

                  // Email
                  TextFormField(
                    controller: _emailCtrl,
                    textAlign: TextAlign.right,
                    decoration:
                    _inputDecoration('البريد الإلكتروني', Icons.email),
                  ),

                  const SizedBox(height: 12),

                  // Password
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    textAlign: TextAlign.right,
                    decoration:
                    _inputDecoration('كلمة المرور', Icons.lock),
                  ),

                  const SizedBox(height: 12),

                  // Error
                  if (_errorText != null) ...[
                    Text(
                      _errorText!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                  ],

                  const SizedBox(height: 12),

                  // Login
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _loading ? null : _signIn,
                      child: _loading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        'تسجيل الدخول',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Google
                  SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        signInWithGoogle();
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.black54,
                      ),
                      label: const Text(
                        'تسجيل الدخول باستخدام Google',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          '© ${DateTime.now().year} Glow Care',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      prefixIcon: Icon(icon),
      prefixIconConstraints: const BoxConstraints(
        minWidth: 50,
        minHeight: 50,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}