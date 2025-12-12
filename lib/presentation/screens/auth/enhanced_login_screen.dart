import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/navigation_service.dart';
import '../../bloc/auth/auth_bloc.dart';

class EnhancedLoginScreen extends StatefulWidget {
  const EnhancedLoginScreen({super.key});

  @override
  State<EnhancedLoginScreen> createState() => _EnhancedLoginScreenState();
}

class _EnhancedLoginScreenState extends State<EnhancedLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  String? _errorMessage;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          setState(() => _isLoading = false);
          _showSuccessMessage('Giriş başarılı!');
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted && context.mounted) {
              NavigationService.goToMain(context);
            }
          });
        } else if (state is AuthError) {
          setState(() {
            _isLoading = false;
            _errorMessage = state.message;
          });
        } else if (state is PasswordResetSent) {
          setState(() => _isLoading = false);
          _showSuccessMessage('Şifre sıfırlama bağlantısı gönderildi');
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
            onPressed: () => context.go('/onboarding'),
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF64748B)),
            tooltip: 'Geri',
          ),
        ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildEmailField(),
                    const SizedBox(height: 16),
                    _buildPasswordField(),
                    const SizedBox(height: 12),
                    _buildOptionsRow(),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      _buildErrorDisplay(),
                    ],
                    const SizedBox(height: 32),
                    _buildLoginButton(),
                    const SizedBox(height: 24),
                    _buildDivider(),
                    const SizedBox(height: 24),
                    _buildSocialLogins(),
                    const SizedBox(height: 24),
                    _buildGuestButton(),
                    const SizedBox(height: 16),
                    _buildRegisterLink(),
                    const SizedBox(height: 20),
                  ],
                ),
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
        Hero(
          tag: 'app_logo',
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF003875), Color(0xFF0055AA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003875).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.shield,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Hoş Geldiniz',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'TULPARS hesabınıza giriş yapın',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      enabled: !_isLoading,
      decoration: InputDecoration(
        labelText: 'E-posta Adresi',
        hintText: 'ornek@email.com',
        prefixIcon: Icon(
          Icons.email_outlined,
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF003875), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'E-posta adresi gerekli';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Geçerli bir e-posta adresi girin';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.done,
      enabled: !_isLoading,
      onFieldSubmitted: (_) => _handleLogin(),
      decoration: InputDecoration(
        labelText: 'Şifre',
        hintText: 'Şifrenizi girin',
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Colors.grey[600],
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[600],
          ),
          tooltip: _isPasswordVisible ? 'Şifreyi gizle' : 'Şifreyi göster',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF003875), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Şifre gerekli';
        }
        if (value.length < 6) {
          return 'Şifre en az 6 karakter olmalı';
        }
        return null;
      },
    );
  }

  Widget _buildOptionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: _isLoading
                  ? null
                  : (value) => setState(() => _rememberMe = value ?? false),
              activeColor: const Color(0xFF003875),
            ),
            const Text(
              'Beni Hatırla',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        TextButton(
          onPressed: _isLoading ? null : _handleForgotPassword,
          child: const Text(
            'Şifremi Unuttum',
            style: TextStyle(
              color: Color(0xFF003875),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorDisplay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade100.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade600,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003875),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Giriş Yap',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'veya',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: _isLoading
                ? null
                : () => context.read<AuthBloc>().add(GoogleSignInRequested()),
            icon: const Icon(
              Icons.g_mobiledata,
              size: 24,
              color: Color(0xFFDC2626),
            ),
            label: const Text('Google ile Devam Et'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey[700],
              side: BorderSide(color: Colors.grey[300]!),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: _isLoading
                ? null
                : () => context.read<AuthBloc>().add(AppleSignInRequested()),
            icon: const Icon(Icons.apple, size: 24, color: Colors.black),
            label: const Text('Apple ile Devam Et'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              side: BorderSide(color: Colors.grey[300]!),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestButton() {
    return TextButton(
      onPressed: _isLoading ? null : _handleGuestLogin,
      child: Text(
        'Misafir Olarak Devam Et',
        style: TextStyle(
          color: _isLoading ? Colors.grey.shade400 : Colors.grey.shade600,
          fontSize: 16,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Hesabınız yok mu? ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: _isLoading ? null : _handleRegisterNavigation,
          child: const Text(
            'Kayıt Olun',
            style: TextStyle(
              color: Color(0xFF003875),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    // Demo login for testing
    if (_isDemoLogin(email, password)) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessMessage('Demo giriş başarılı!');
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted && context.mounted) {
          NavigationService.goToMain(context);
        }
      }
      return;
    }

    // Real Firebase login
    if (mounted) {
      context.read<AuthBloc>().add(
            LoginRequested(email: email, password: password),
          );
    }
  }

  bool _isDemoLogin(String email, String password) {
    const demoAccounts = {
      'demo@test.com': '123456',
      'admin@tulpars.com': 'admin123',
      'test@example.com': 'test123',
    };
    return demoAccounts[email] == password;
  }

  void _handleForgotPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() => _errorMessage = 'Lütfen e-posta adresinizi girin');
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _errorMessage = 'Geçerli bir e-posta adresi girin');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Şifre Sıfırlama'),
        content:
            Text('$email adresine şifre sıfırlama bağlantısı gönderilsin mi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003875),
            ),
            child: const Text('Gönder'),
          ),
        ],
      ),
    );

    if ((confirmed ?? false) && mounted) {
      context.read<AuthBloc>().add(PasswordResetRequested(email: email));
    }
  }

  void _handleGuestLogin() {
    NavigationService.goToMain(context);
  }

  void _handleRegisterNavigation() {
    NavigationService.goToRegister(context);
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
