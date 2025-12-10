import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/services/navigation_service.dart';
import '../../bloc/auth/auth_bloc.dart';

class EnhancedLoginScreen extends StatefulWidget {
  const EnhancedLoginScreen({super.key});

  @override
  State<EnhancedLoginScreen> createState() => _EnhancedLoginScreenState();
}

class _EnhancedLoginScreenState extends State<EnhancedLoginScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _shortcutController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _shortcutFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _canCheckBiometrics = false;
  bool _isBiometricSupported = false;
  bool _isNetworkAvailable = true;
  int _loginAttempts = 0;
  DateTime? _lastFailedAttempt;
  String _currentError = '';
  bool _showShortcutField = false;

  final LocalAuthentication _localAuth = LocalAuthentication();
  late AnimationController _animationController;
  late AnimationController _shakeController;
  late AnimationController _errorController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _shakeAnimation;
  late Animation<Color?> _errorColorAnimation;

  // Keyboard shortcuts map
  final Map<String, VoidCallback> _shortcuts = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();
    _setupKeyboardShortcuts();
    _checkBiometricSupport();
    _checkNetworkStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _emailController.dispose();
    _passwordController.dispose();
    _shortcutController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _shortcutFocusNode.dispose();
    _animationController.dispose();
    _shakeController.dispose();
    _errorController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _errorController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _errorColorAnimation = ColorTween(
      begin: Colors.transparent,
      end: const Color(0xFFDC2626).withValues(alpha: 0.1),
    ).animate(_errorController);

    _animationController.forward();
  }

  void _setupKeyboardShortcuts() {
    _shortcuts.addAll({
      'Ctrl+L': () => _emailFocusNode.requestFocus(),
      'Ctrl+P': () => _passwordFocusNode.requestFocus(),
      'Ctrl+Enter': _handleLogin,
      'Ctrl+R': _handleRegisterNavigation,
      'Ctrl+F': _handleForgotPassword,
      'Ctrl+G': _handleGuestLogin,
      'Ctrl+B': _authenticateWithBiometrics,
      'Ctrl+S': () => _toggleShortcutField(),
      'F1': _showKeyboardShortcuts,
      'Escape': () => _clearForm(),
    });
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
      _handleError('Biyometrik kontrol hatası: ${e.message}', isNetworkError: false);
    }
  }

  Future<void> _checkNetworkStatus() async {
    // Simulate network check
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isNetworkAvailable = true; // In real app, check actual network status
      });
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (!_isBiometricSupported || !_canCheckBiometrics) {
      _handleError('Biyometrik doğrulama bu cihazda desteklenmiyor', isNetworkError: false);
      return;
    }

    try {
      setState(() => _isLoading = true);
      
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Tulpars uygulamasına giriş yapmak için biyometrik kimliğinizi doğrulayın',

      );

      if (authenticated && mounted) {
        _showSuccessMessage('Biyometrik doğrulama başarılı');
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          NavigationService.goToMain(context);
        }
      }
    } on PlatformException catch (e) {
      var errorMessage = 'Biyometrik doğrulama başarısız';
      switch (e.code) {
        case 'NotAvailable':
          errorMessage = 'Biyometrik doğrulama mevcut değil';
          break;
        case 'NotEnrolled':
          errorMessage = 'Biyometrik veri kayıtlı değil';
          break;
        case 'LockedOut':
          errorMessage = 'Çok fazla başarısız deneme. Lütfen bekleyin';
          break;
        case 'UserCancel':
          errorMessage = 'Kullanıcı tarafından iptal edildi';
          break;
      }
      _handleError(errorMessage, isNetworkError: false);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleLogin() async {
    if (_isRateLimited()) {
      _handleError('Çok fazla başarısız deneme. 5 dakika sonra tekrar deneyin', isNetworkError: false);
      return;
    }

    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      _triggerShakeAnimation();
      return;
    }

    if (!_isNetworkAvailable) {
      _handleError('İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin', isNetworkError: true);
      return;
    }

    setState(() {
      _isLoading = true;
      _currentError = '';
    });

    try {
      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text;

      // Enhanced demo login with shortcut support
      if (_isDemoLogin(email, password) || _isShortcutLogin()) {
        await _simulateNetworkDelay();
        if (mounted) {
          setState(() => _isLoading = false);
          _showSuccessMessage('Demo giriş başarılı!');
          _resetLoginAttempts();
          await Future.delayed(const Duration(milliseconds: 800));
          if (mounted) {
            NavigationService.goToMain(context);
          }
        }
        return;
      }

      // Real Firebase login
      if (mounted) {
        context.read<AuthBloc>().add(
              LoginRequested(
                email: email,
                password: password,
              ),
            );
      }
    } catch (e) {
      _handleLoginFailure('Beklenmeyen bir hata oluştu: ${e.toString()}');
    }
  }

  bool _isDemoLogin(String email, String password) {
    final demoAccounts = {
      'demo@test.com': '123456',
      'admin@tulpars.com': 'admin123',
      'test@example.com': 'test123',
      'user@demo.com': 'demo2024',
    };
    return demoAccounts[email] == password;
  }

  bool _isShortcutLogin() {
    final shortcut = _shortcutController.text.trim();
    final shortcuts = ['DEMO', 'ADMIN', 'TEST', 'QUICK'];
    return shortcuts.contains(shortcut.toUpperCase());
  }

  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(Duration(milliseconds: 800 + (DateTime.now().millisecond % 400)));
  }

  void _handleLoginFailure(String message) {
    setState(() {
      _isLoading = false;
      _loginAttempts++;
      _lastFailedAttempt = DateTime.now();
    });
    _handleError(message, isNetworkError: false);
    _triggerShakeAnimation();
  }

  bool _isRateLimited() {
    if (_loginAttempts >= 5 && _lastFailedAttempt != null) {
      final timeDiff = DateTime.now().difference(_lastFailedAttempt!);
      return timeDiff.inMinutes < 5;
    }
    return false;
  }

  void _resetLoginAttempts() {
    setState(() {
      _loginAttempts = 0;
      _lastFailedAttempt = null;
    });
  }

  void _handleForgotPassword() async {
    final email = _emailController.text.trim().toLowerCase();

    if (email.isEmpty) {
      _handleError('Lütfen e-posta adresinizi girin', isNetworkError: false);
      _emailFocusNode.requestFocus();
      return;
    }

    if (!_isValidEmail(email)) {
      _handleError('Geçerli bir e-posta adresi girin', isNetworkError: false);
      _emailFocusNode.requestFocus();
      return;
    }

    final confirmed = await _showResetConfirmationDialog(email);
    if (!confirmed || !mounted) return;

    if (!_isNetworkAvailable) {
      _handleError('İnternet bağlantısı gerekli', isNetworkError: true);
      return;
    }

    context.read<AuthBloc>().add(
          PasswordResetRequested(email: email),
        );
  }

  void _handleRegisterNavigation() {
    NavigationService.goToRegister(context);
  }

  void _handleGuestLogin() {
    NavigationService.goToMain(context);
  }

  void _toggleShortcutField() {
    setState(() {
      _showShortcutField = !_showShortcutField;
    });
    if (_showShortcutField) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _shortcutFocusNode.requestFocus();
      });
    }
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _shortcutController.clear();
    setState(() {
      _currentError = '';
      _rememberMe = false;
      _showShortcutField = false;
    });
  }

  void _showKeyboardShortcuts() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Klavye Kısayolları'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildShortcutItem('Ctrl+L', 'E-posta alanına odaklan'),
              _buildShortcutItem('Ctrl+P', 'Şifre alanına odaklan'),
              _buildShortcutItem('Ctrl+Enter', 'Giriş yap'),
              _buildShortcutItem('Ctrl+R', 'Kayıt ol sayfasına git'),
              _buildShortcutItem('Ctrl+F', 'Şifremi unuttum'),
              _buildShortcutItem('Ctrl+G', 'Misafir girişi'),
              _buildShortcutItem('Ctrl+B', 'Biyometrik giriş'),
              _buildShortcutItem('Ctrl+S', 'Kısayol alanını aç/kapat'),
              _buildShortcutItem('F1', 'Bu yardım menüsü'),
              _buildShortcutItem('Escape', 'Formu temizle'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutItem(String shortcut, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              shortcut,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(description)),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  Future<bool> _showResetConfirmationDialog(String email) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Şifre Sıfırlama'),
            content: Text(
              '$email adresine şifre sıfırlama bağlantısı gönderilsin mi?',
            ),
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
        ) ??
        false;
  }

  void _handleError(String message, {required bool isNetworkError}) {
    setState(() {
      _currentError = message;
    });
    _errorController.forward().then((_) {
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) {
          _errorController.reverse();
        }
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isNetworkError ? Icons.wifi_off : Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
            if (isNetworkError)
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  _checkNetworkStatus();
                },
                child: const Text(
                  'Yeniden Dene',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: Duration(seconds: isNetworkError ? 10 : 4),
      ),
    );
  }

  void _showSuccessMessage(String message) {
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

  void _triggerShakeAnimation() {
    _shakeController.forward().then((_) => _shakeController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          setState(() => _isLoading = false);
          _showSuccessMessage('Giriş başarılı!');
          _resetLoginAttempts();
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              NavigationService.goToMain(context);
            }
          });
        } else if (state is AuthError) {
          _handleLoginFailure(state.message);
        } else if (state is PasswordResetSent) {
          setState(() => _isLoading = false);
          _showSuccessMessage(
            'Şifre sıfırlama bağlantısı ${state.email} adresine gönderildi',
          );
        } else if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else if (state is Unauthenticated) {
          setState(() => _isLoading = false);
        }
      },
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyL):
              const _FocusEmailIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyP):
              const _FocusPasswordIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.enter):
              const _LoginIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyR):
              const _RegisterIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
              const _ForgotPasswordIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyG):
              const _GuestLoginIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB):
              const _BiometricIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
              const _ShortcutToggleIntent(),
          LogicalKeySet(LogicalKeyboardKey.f1): const _HelpIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): const _ClearFormIntent(),
        },
        child: Actions(
          actions: {
            _FocusEmailIntent: CallbackAction<_FocusEmailIntent>(
              onInvoke: (_) => _emailFocusNode.requestFocus(),
            ),
            _FocusPasswordIntent: CallbackAction<_FocusPasswordIntent>(
              onInvoke: (_) => _passwordFocusNode.requestFocus(),
            ),
            _LoginIntent: CallbackAction<_LoginIntent>(
              onInvoke: (_) => _handleLogin(),
            ),
            _RegisterIntent: CallbackAction<_RegisterIntent>(
              onInvoke: (_) => _handleRegisterNavigation(),
            ),
            _ForgotPasswordIntent: CallbackAction<_ForgotPasswordIntent>(
              onInvoke: (_) => _handleForgotPassword(),
            ),
            _GuestLoginIntent: CallbackAction<_GuestLoginIntent>(
              onInvoke: (_) => _handleGuestLogin(),
            ),
            _BiometricIntent: CallbackAction<_BiometricIntent>(
              onInvoke: (_) => _authenticateWithBiometrics(),
            ),
            _ShortcutToggleIntent: CallbackAction<_ShortcutToggleIntent>(
              onInvoke: (_) => _toggleShortcutField(),
            ),
            _HelpIntent: CallbackAction<_HelpIntent>(
              onInvoke: (_) => _showKeyboardShortcuts(),
            ),
            _ClearFormIntent: CallbackAction<_ClearFormIntent>(
              onInvoke: (_) => _clearForm(),
            ),
          },
          child: Focus(
            autofocus: true,
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
                actions: [
                  // Network status indicator
                  if (!_isNetworkAvailable)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Tooltip(
                        message: 'İnternet bağlantısı yok',
                        child: Icon(
                          Icons.wifi_off,
                          color: Colors.red.shade600,
                          size: 20,
                        ),
                      ),
                    ),
                  // Help button
                  IconButton(
                    icon: const Icon(Icons.help_outline, color: Color(0xFF64748B)),
                    onPressed: _showKeyboardShortcuts,
                    tooltip: 'Klavye kısayolları (F1)',
                  ),
                ],
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
                    child: AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(_shakeAnimation.value, 0),
                          child: child,
                        );
                      },
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: AnimatedBuilder(
                          animation: _errorColorAnimation,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                color: _errorColorAnimation.value,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: child,
                            );
                          },
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
                                if (_showShortcutField) ...[
                                  const SizedBox(height: 16),
                                  _buildShortcutField(),
                                ],
                                const SizedBox(height: 12),
                                _buildOptionsRow(),
                                if (_currentError.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  _buildErrorDisplay(),
                                ],
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
                                _buildKeyboardShortcutsHint(),
                              ],
                            ),
                          ),
                        ),
                      ),
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
          'Gelişmiş Giriş Sistemi',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        _buildDemoAccountsInfo(),
      ],
    );
  }

  Widget _buildDemoAccountsInfo() {
    return Container(
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
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Color(0xFF10B981),
              ),
              SizedBox(width: 8),
              Text(
                'Demo Hesaplar & Kısayollar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• demo@test.com / 123456',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '• admin@tulpars.com / admin123',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '• Kısayol kodları: DEMO, ADMIN, TEST, QUICK',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Semantics(
      label: 'E-posta adresi giriş alanı',
      hint: 'Geçerli bir e-posta adresi girin. Ctrl+L ile odaklanabilirsiniz',
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
          helperText: 'Ctrl+L ile odaklan',
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Colors.grey.shade600,
          ),
          suffixIcon: _emailController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _emailController.clear(),
                )
              : null,
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
          final email = value.trim().toLowerCase();
          if (!_isValidEmail(email)) {
            return 'Geçerli bir e-posta adresi girin';
          }
          if (email.length > 254) {
            return 'E-posta adresi çok uzun';
          }
          return null;
        },
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Semantics(
      label: 'Şifre giriş alanı',
      hint: 'En az 6 karakterli şifrenizi girin. Ctrl+P ile odaklanabilirsiniz',
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
          helperText: 'Ctrl+P ile odaklan, Enter ile giriş yap',
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey.shade600,
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_passwordController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _passwordController.clear(),
                ),
              Semantics(
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
            ],
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
          if (value.length > 128) {
            return 'Şifre çok uzun';
          }
          return null;
        },
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildShortcutField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Semantics(
        label: 'Hızlı giriş kısayol alanı',
        hint: 'DEMO, ADMIN, TEST veya QUICK yazın',
        textField: true,
        child: TextFormField(
          controller: _shortcutController,
          focusNode: _shortcutFocusNode,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.done,
          enabled: !_isLoading,
          onFieldSubmitted: (_) => _handleLogin(),
          decoration: InputDecoration(
            labelText: 'Hızlı Giriş Kısayolu',
            hintText: 'DEMO, ADMIN, TEST, QUICK',
            helperText: 'Ctrl+S ile aç/kapat',
            prefixIcon: Icon(
              Icons.flash_on,
              color: Colors.orange.shade600,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: _toggleShortcutField,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.orange.shade600, width: 2),
            ),
            filled: true,
            fillColor: Colors.orange.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
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
        Row(
          children: [
            TextButton.icon(
              onPressed: _isLoading ? null : _toggleShortcutField,
              icon: Icon(
                _showShortcutField ? Icons.flash_off : Icons.flash_on,
                size: 16,
              ),
              label: const Text('Kısayol'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange.shade600,
                padding: const EdgeInsets.symmetric(horizontal: 8),
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
        ),
      ],
    );
  }

  Widget _buildErrorDisplay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDC2626).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFDC2626).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFDC2626),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _currentError,
              style: const TextStyle(
                color: Color(0xFFDC2626),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_loginAttempts > 0)
            Text(
              '$_loginAttempts/5',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Semantics(
      label: _isLoading
          ? 'Giriş yapılıyor, lütfen bekleyin'
          : 'Giriş yap butonu. Ctrl+Enter ile de giriş yapabilirsiniz',
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
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Giriş Yap',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 8),
                    Opacity(
                      opacity: 0.8,
                      child: Text(
                        '(Ctrl+Enter)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
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
        label: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Biyometrik Giriş',
              style: TextStyle(
                color: Color(0xFF003875),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Opacity(
              opacity: 0.7,
              child: Text(
                '(Ctrl+B)',
                style: TextStyle(
                  color: Color(0xFF003875),
                  fontSize: 12,
                ),
              ),
            ),
          ],
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
        Expanded(
          child: Divider(color: Colors.grey.shade300, thickness: 1),
        ),
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
        Expanded(
          child: Divider(color: Colors.grey.shade300, thickness: 1),
        ),
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
        'Misafir Olarak Devam Et (Ctrl+G)',
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
          onPressed: _isLoading ? null : _handleRegisterNavigation,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Kayıt Olun (Ctrl+R)',
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

  Widget _buildKeyboardShortcutsHint() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(
            Icons.keyboard,
            color: Colors.blue.shade600,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Klavye kısayolları için F1 tuşuna basın',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: _showKeyboardShortcuts,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
            ),
            child: const Text('F1'),
          ),
        ],
      ),
    );
  }
}

// Intent classes for keyboard shortcuts
class _FocusEmailIntent extends Intent {
  const _FocusEmailIntent();
}

class _FocusPasswordIntent extends Intent {
  const _FocusPasswordIntent();
}

class _LoginIntent extends Intent {
  const _LoginIntent();
}

class _RegisterIntent extends Intent {
  const _RegisterIntent();
}

class _ForgotPasswordIntent extends Intent {
  const _ForgotPasswordIntent();
}

class _GuestLoginIntent extends Intent {
  const _GuestLoginIntent();
}

class _BiometricIntent extends Intent {
  const _BiometricIntent();
}

class _ShortcutToggleIntent extends Intent {
  const _ShortcutToggleIntent();
}

class _HelpIntent extends Intent {
  const _HelpIntent();
}

class _ClearFormIntent extends Intent {
  const _ClearFormIntent();
}