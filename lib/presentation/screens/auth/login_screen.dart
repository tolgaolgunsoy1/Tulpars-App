import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/services/navigation_service.dart';
import '../../bloc/auth/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _canCheckBiometrics = false;
  bool _isBiometricSupported = false;

  final LocalAuthentication _localAuth = LocalAuthentication();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      _canCheckBiometrics = await _localAuth.canCheckBiometrics;
      _isBiometricSupported = await _localAuth.isDeviceSupported();
      setState(() {});
    } on PlatformException catch (e) {
      debugPrint('Biometric check failed: $e');
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason:
            'Tulpars uygulamasına giriş yapmak için biyometrik kimliğinizi doğrulayın',
      );
      if (authenticated && mounted) {
        NavigationService.goToMain(context);
      }
    } on PlatformException catch (e) {
      debugPrint('Biometric authentication failed: $e');
      _showErrorSnackBar('Biyometrik doğrulama başarısız oldu');
    }
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
          LoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  void _handleForgotPassword() async {
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Lütfen e-posta adresinizi girin');
      return;
    }

    context.read<AuthBloc>().add(
          PasswordResetRequested(email: _emailController.text.trim()),
        );
  }

  void _handleGuestLogin() {
    NavigationService.goToMain(context);
  }

  void _showErrorSnackBar(String message) {
    NavigationService.showErrorSnackBar(context, message);
  }

  void _showSuccessSnackBar(String message) {
    NavigationService.showSuccessSnackBar(context, message);
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
        } else if (state is PasswordResetSent) {
          _showSuccessSnackBar(
            'Şifre sıfırlama bağlantısı ${state.email} adresine gönderildi',
          );
        } else if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else if (state is Unauthenticated) {
          setState(() => _isLoading = false);
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // Logo and Title
                    _buildHeader(),

                    const SizedBox(height: 48),

                    // Email Field
                    _buildEmailField(),

                    const SizedBox(height: 16),

                    // Password Field
                    _buildPasswordField(),

                    const SizedBox(height: 12),

                    // Remember Me & Forgot Password
                    _buildOptionsRow(),

                    const SizedBox(height: 32),

                    // Login Button
                    _buildLoginButton(),

                    const SizedBox(height: 24),

                    // Biometric Login (if available)
                    if (_isBiometricSupported && _canCheckBiometrics)
                      _buildBiometricButton(),

                    const SizedBox(height: 24),

                    // Divider
                    _buildDivider(),

                    const SizedBox(height: 24),

                    // Social Login Options
                    _buildSocialLogins(),

                    const SizedBox(height: 32),

                    // Guest Login
                    _buildGuestButton(),

                    const SizedBox(height: 24),

                    // Register Link
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
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF003875),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF003875).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.emergency, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 24),
        const Text(
          'TULPARS',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF003875),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hesabınıza Giriş Yapın',
          style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Semantics(
      label: 'E-posta adresi giriş alanı',
      hint: 'Geçerli bir e-posta adresi girin',
      textField: true,
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: 'E-posta Adresi',
          hintText: 'ornek@email.com',
          prefixIcon:
              const Icon(Icons.email_outlined, color: Color(0xFF64748B)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF003875), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'E-posta adresi gerekli';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Geçerli bir e-posta adresi girin';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Semantics(
      label: 'Şifre giriş alanı',
      hint: 'En az 6 karakterli şifrenizi girin',
      textField: true,
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _handleLogin(),
        decoration: InputDecoration(
          labelText: 'Şifre',
          hintText: 'Şifrenizi girin',
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B)),
          suffixIcon: Semantics(
            label: _isPasswordVisible ? 'Şifreyi gizle' : 'Şifreyi göster',
            button: true,
            child: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF64748B),
              ),
              onPressed: () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              },
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF003875), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
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
      ),
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
              onChanged: (value) {
                setState(() => _rememberMe = value ?? false);
              },
              activeColor: const Color(0xFF003875),
            ),
            const Text(
              'Beni Hatırla',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ],
        ),
        TextButton(
          onPressed: _handleForgotPassword,
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

  Widget _buildLoginButton() {
    return Semantics(
      label:
          _isLoading ? 'Giriş yapılıyor, lütfen bekleyin' : 'Giriş yap butonu',
      button: true,
      enabled: !_isLoading,
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003875),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            shadowColor: Colors.transparent,
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
        ),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: _authenticateWithBiometrics,
        icon: const Icon(Icons.fingerprint, color: Color(0xFF003875), size: 24),
        label: const Text(
          'Biyometrik Giriş',
          style: TextStyle(
            color: Color(0xFF003875),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF003875)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('veya', style: TextStyle(color: Colors.grey.shade500)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(GoogleSignInRequested());
            },
            icon: const Icon(
              Icons.g_mobiledata,
              size: 32,
              color: Color(0xFFDC2626),
            ),
            label: const Text(
              'Google ile Devam Et',
              style: TextStyle(fontSize: 16, color: Color(0xFF0F172A)),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(AppleSignInRequested());
            },
            icon: const Icon(Icons.apple, size: 28, color: Color(0xFF0F172A)),
            label: const Text(
              'Apple ile Devam Et',
              style: TextStyle(fontSize: 16, color: Color(0xFF0F172A)),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFCBD5E1)),
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
      onPressed: _handleGuestLogin,
      child: const Text(
        'Misafir Olarak Devam Et',
        style: TextStyle(
          color: Color(0xFF64748B),
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
        const Text(
          'Hesabınız yok mu? ',
          style: TextStyle(color: Color(0xFF64748B)),
        ),
        TextButton(
          onPressed: () => NavigationService.goToRegister(context),
          child: const Text(
            'Kayıt Olun',
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
