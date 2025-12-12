import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/onboarding'),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/appstore.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.shield, color: Colors.white, size: 35);
                      },
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              const Text(
                'TULPARS',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0055AA),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Username Field (Instagram style)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Telefon numarası, kullanıcı adı veya e-posta',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Password Field (Instagram style)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    hintText: 'Şifre',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      icon: Text(
                        _isPasswordVisible ? 'Gizle' : 'Göster',
                        style: const TextStyle(
                          color: Color(0xFF0055AA),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Login Button (Instagram style)
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0055AA),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Giriş Yap',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Forgot Password
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Şifre sıfırlama e-postası gönderildi')),
                  );
                },
                child: const Text(
                  'Şifreni mi unuttun?',
                  style: TextStyle(
                    color: Color(0xFF0055AA),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'YA DA',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Guest Login
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Misafir olarak giriş yapıldı!')),
                  );
                  context.go('/main');
                },
                icon: const Icon(Icons.person_outline, color: Color(0xFF0055AA)),
                label: const Text(
                  'Misafir Olarak Devam Et',
                  style: TextStyle(
                    color: Color(0xFF0055AA),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              const SizedBox(height: 80),
              
              // Sign Up Link
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Hesabın yok mu? ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/register'),
                      child: const Text(
                        'Kaydol',
                        style: TextStyle(
                          color: Color(0xFF0055AA),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() => _isLoading = false);
      
      final email = _usernameController.text.toLowerCase();
      final isAdmin = email.contains('admin');
      
      final userBox = Hive.box('user_data');
      await userBox.put('isLoggedIn', true);
      await userBox.put('isAdmin', isAdmin);
      await userBox.put('userEmail', email);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAdmin ? 'Admin girişi başarılı!' : 'Giriş başarılı!'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/main');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}