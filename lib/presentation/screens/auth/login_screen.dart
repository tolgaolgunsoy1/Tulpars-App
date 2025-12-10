import 'dart:async';
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
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _canCheckBiometrics = false;
  bool _isBiometricSupported = false;

  final LocalAuthentication _localAuth = LocalAuthentication();

  late AnimationController _animationController;
  late AnimationController _shakeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.05, 0),
    ).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.elasticIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      
      if (mounted) {
        setState(() {
          _canCheckBiometrics = canCheck;
          _isBiometricSupported = isSupported;
        });
      }
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
        _showSuccessSnackBar('Biyometrik doğrulama başarılı');
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          NavigationService.goToMain(context);
        }
      }
    } on PlatformException catch (e) {
      debugPrint('Biometric authentication failed: $e');
      if (mounted) {
        _showErrorSnackBar('Biyometrik doğrulama başarısız oldu');
      }
    }
  }

  void _handleLogin() async {
    // Klavyeyi kapat
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      _shakeController.forward(from: 0);
      return;
    }

    setState(() => _isLoading = true);

    // Demo login kontrolü
    if (_emailController.text.trim() == 'demo@test.com' && 
        _passwordController.text == '123456') {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessSnackBar('Demo giriş başarılı!');
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          NavigationService.goToMain(context);
        }
      }
      return;
    }

    // Gerçek login
    if (mounted) {
      context.read<AuthBloc>().add(
            LoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  void _handleForgotPassword() async {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      _showErrorSnackBar('Lütfen e-posta adresinizi girin');
      _emailFocusNode.requestFocus();
      return;
    }

    // Email validasyonu
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showErrorSnackBar('Geçerli bir e-posta adresi girin');
      _emailFocusNode.requestFocus();
      return;
    }

    context.read<AuthBloc>().add(
          PasswordResetRequested(email: email),
        );
  }

  void _handleGuestLogin() {
    NavigationService.goToMain(context);
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    NavigationService.showErrorSnackBar(context, message);
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    NavigationService.showSuccessSnackBar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          setState(() => _isLoading = false);
          _showSuccessSnackBar('Giriş başarılı!');
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              NavigationService.goToMain(context);
            }
          });
        } else if (state is AuthError) {
          setState(() => _isLoading = false);
          _shakeController.forward(from: 0);
          _showErrorSnackBar(state.message);
        } else if (state is PasswordResetSent) {
          setState(() => _isLoading = false);
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
            icon: const Icon(Icons.arrow_back, color: Color(0xFF64748B)),
            onPressed: () => NavigationService.goBack(
              context,
              fallbackRoute: '/auth',
            ),
          ),
        ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: AnimatedBuilder(
              animation: _slideAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: child,
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: SlideTransition(
                  position: _shakeAnimation,
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        _buildHeader(),
                        const SizedBox(height: 48),
                        _buildEmailField(),
                        const SizedBox(height: 16),
                        _buildPasswordField(),
                        const SizedBox(height: 12),
                        _buildOptionsRow(),
                        const SizedBox(height: 32),
                        _buildLoginButton(),
                        if (_isBiometricSupported && _canCheckBiometrics) ...[
                          const SizedBox(height: 16),
                          _buildBiometricButton(),
                        ],
                        const SizedBox(height: 32),
                        _buildDivider(),
                        const SizedBox(height: 24),
                        _buildSocialLogins(),
                        const SizedBox(height: 32),
                        _buildGuestButton(),
                        const SizedBox(height: 24),
                        _buildRegisterLink(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF003875), Color(0xFF0055AA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003875).withValues(alpha: 0.3),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.emergency, size: 50, color: Colors.white),
          ),
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
        Text(
          'Hesabınıza Giriş Yapın',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF10B981).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Color(0xFF10B981),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Demo Giriş Bilgileri',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'E-posta: demo@test.com',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Şifre: 123456',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
        focusNode: _emailFocusNode,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        enabled: !_isLoading,
        onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
        decoration: InputDecoration(
          labelText: 'E-posta Adresi',
          hintText: 'ornek@email.com',
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Colors.grey.shade600,
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
            borderSide: const BorderSide(color: Color(0xFFDC2626)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
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
        focusNode: _passwordFocusNode,
        obscureText: !_isPasswordVisible,
        textInputAction: TextInputAction.done,
        enabled: !_isLoading,
        onFieldSubmitted: (_) => _handleLogin(),
        decoration: InputDecoration(
          labelText: 'Şifre',
          hintText: 'Şifrenizi girin',
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey.shade600,
          ),
          suffixIcon: Semantics(
            label: _isPasswordVisible ? 'Şifreyi gizle' : 'Şifreyi göster',
            button: true,
            child: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() => _isPasswordVisible = !_isPasswordVisible);
              },
            ),
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
            borderSide: const BorderSide(color: Color(0xFFDC2626)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDC2626), width: 2),
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
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          setState(() => _rememberMe = value ?? false);
                        },
                  activeColor: const Color(0xFF003875),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Beni Hatırla',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: _isLoading ? null : _handleForgotPassword,
          child: const Text(
            'Şifremi Unuttum',
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

  Widget _buildLoginButton() {
    return Semantics(
      label: _isLoading
          ? 'Giriş yapılıyor, lütfen bekleyin'
          : 'Giriş yap butonu',
      button: true,
      enabled: !_isLoading,
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF003875),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey.shade400,
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
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Giriş Yap',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: _isLoading ? null : _authenticateWithBiometrics,
        icon: const Icon(
          Icons.fingerprint,
          color: Color(0xFF003875),
          size: 28,
        ),
        label: const Text(
          'Biyometrik Giriş',
          style: TextStyle(
            color: Color(0xFF003875),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF003875), width: 1.5),
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
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'veya',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialLogins() {
    return Column(
      children: [
        SizedBox(
          height: 56,
          child: OutlinedButton.icon(
            onPressed: _isLoading
                ? null
                : () {
                    context.read<AuthBloc>().add(GoogleSignInRequested());
                  },
            icon: const Icon(
              Icons.g_mobiledata,
              size: 32,
              color: Color(0xFFDC2626),
            ),
            label: const Text(
              'Google ile Devam Et',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey.shade300),
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
            onPressed: _isLoading
                ? null
                : () {
                    context.read<AuthBloc>().add(AppleSignInRequested());
                  },
            icon: const Icon(Icons.apple, size: 28, color: Color(0xFF0F172A)),
            label: const Text(
              'Apple ile Devam Et',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey.shade300),
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
          fontWeight: FontWeight.w500,
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
            color: Colors.grey.shade600,
            fontSize: 15,
          ),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () => NavigationService.goToRegister(context),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Kayıt Olun',
            style: TextStyle(
              color: Color(0xFF003875),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}