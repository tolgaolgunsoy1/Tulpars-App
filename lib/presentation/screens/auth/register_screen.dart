import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/navigation_service.dart';
import '../../bloc/auth/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    // Klavyeyi kapat
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      _showErrorSnackBar('Kullanım şartlarını ve gizlilik politikasını kabul etmelisiniz');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text;

      // Enhanced validation
      if (!_isValidName(name)) {
        _showErrorSnackBar('Geçerli bir ad soyad girin');
        setState(() => _isLoading = false);
        return;
      }

      if (!_isValidEmail(email)) {
        _showErrorSnackBar('Geçerli bir e-posta adresi girin');
        setState(() => _isLoading = false);
        return;
      }

      if (_isWeakPassword(password)) {
        _showErrorSnackBar('Daha güçlü bir şifre seçin');
        setState(() => _isLoading = false);
        return;
      }

      // Demo register for testing
      if (_isDemoRegister(email)) {
        await Future.delayed(const Duration(milliseconds: 1200));
        if (mounted) {
          setState(() => _isLoading = false);
          _showSuccessSnackBar('Demo kayıt başarılı! Hoş geldiniz!');
          await Future.delayed(const Duration(milliseconds: 800));
          if (mounted) {
            NavigationService.goToMain(context);
          }
        }
        return;
      }

      // Real Firebase registration
      if (mounted) {
        context.read<AuthBloc>().add(
              RegisterRequested(
                email: email,
                password: password,
                name: name,
              ),
            );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Kayıt sırasında beklenmeyen bir hata oluştu');
      }
    }
  }

  bool _isDemoRegister(String email) {
    return email.contains('demo') || 
           email.contains('test') || 
           email.endsWith('@example.com');
  }

  bool _isValidName(String name) {
    if (name.length < 2) return false;
    if (name.length > 50) return false;
    // Check if contains at least one letter
    if (!RegExp(r'[a-zA-ZÀ-ÿ]').hasMatch(name)) return false;
    // Check for invalid characters
    if (RegExp(r'[0-9@#$%^&*()_+=\[\]{}|;:,.<>?]').hasMatch(name)) return false;
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  bool _isWeakPassword(String password) {
    if (password.length < 8) return true;
    
    final weakPasswords = {
      '12345678', 'password', 'password123', 'qwerty123', 'abc12345',
      '11111111', '123123123', 'admin123', 'letmein123'
    };
    
    if (weakPasswords.contains(password.toLowerCase())) return true;
    
    // Check for at least one number and one letter
    if (!RegExp(r'(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(password)) return true;
    
    return false;
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          setState(() => _isLoading = false);
          NavigationService.goToMain(context);
        } else if (state is AuthError) {
          setState(() => _isLoading = false);
          _showErrorSnackBar(state.message);
        } else if (state is AuthLoading) {
          setState(() => _isLoading = true);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => NavigationService.goBack(context, fallbackRoute: '/auth'),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildNameField(),
                  const SizedBox(height: 16),
                  _buildEmailField(),
                  const SizedBox(height: 16),
                  _buildPasswordField(),
                  const SizedBox(height: 16),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 16),
                  _buildTermsCheckbox(),
                  const SizedBox(height: 32),
                  _buildRegisterButton(),
                  const SizedBox(height: 24),
                  _buildLoginLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF003875),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.person_add, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text(
          'Hesap Oluştur',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003875),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tulpars ailesine katılın',
          style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Ad Soyad',
        hintText: 'Adınızı ve soyadınızı girin',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ad soyad gerekli';
        }
        final name = value.trim();
        if (name.length < 2) {
          return 'Ad soyad en az 2 karakter olmalı';
        }
        if (name.length > 50) {
          return 'Ad soyad çok uzun';
        }
        if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(name)) {
          return 'Sadece harf ve boşluk kullanın';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'E-posta Adresi',
        hintText: 'ornek@email.com',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'E-posta adresi gerekli';
        }
        final email = value.trim().toLowerCase();
        if (!_isValidEmail(email)) {
          return 'Geçerli bir e-posta adresi girin';
        }
        if (email.length > 254) {
          return 'E-posta adresi çok uzun';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Şifre',
        hintText: 'En az 8 karakter, harf ve rakam',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Şifre gerekli';
        }
        if (value.length < 8) {
          return 'Şifre en az 8 karakter olmalı';
        }
        if (value.length > 128) {
          return 'Şifre çok uzun';
        }
        if (!RegExp(r'(?=.*[a-zA-Z])(?=.*[0-9])').hasMatch(value)) {
          return 'Şifre en az bir harf ve bir rakam içermeli';
        }
        if (_isWeakPassword(value)) {
          return 'Daha güçlü bir şifre seçin';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Şifre Tekrar',
        hintText: 'Şifrenizi tekrar girin',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Şifre tekrarı gerekli';
        }
        if (value != _passwordController.text) {
          return 'Şifreler eşleşmiyor';
        }
        return null;
      },
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() => _acceptTerms = value ?? false);
          },
          activeColor: const Color(0xFF003875),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() => _acceptTerms = !_acceptTerms);
            },
            child: const Text(
              'Kullanım şartlarını ve gizlilik politikasını kabul ediyorum',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003875),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Hesap Oluştur',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Zaten hesabınız var mı? ',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
        TextButton(
          onPressed: () => NavigationService.goToLogin(context),
          child: const Text(
            'Giriş Yapın',
            style: TextStyle(
              color: Color(0xFF003875),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}