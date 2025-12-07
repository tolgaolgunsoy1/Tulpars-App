import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../bloc/auth/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _verificationCodeController = TextEditingController();

  bool _isLoading = false;
  bool _acceptTerms = false;
  bool _acceptMarketing = false;
  bool _isVerificationSent = false;
  int _currentStep = 0; // 0: Personal Info, 1: Verification, 2: Password

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800) vsync: this,);_fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));_animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _verificationCodeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      if (_validateCurrentStep()) {
        setState(() => _currentStep++);
        if (_currentStep == 1 && !_isVerificationSent) {
          _sendVerificationCode();
        }
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _validatePersonalInfo();
      case 1:
        return _validateVerification();
      case 2:
        return _validatePassword();
      default:
        return false;
    }
  }

  bool _validatePersonalInfo() {
    if (_nameController.text.isEmpty) {
      _showErrorSnackBar('Ad alanı zorunludur');
      return false;
    }
    if (_surnameController.text.isEmpty) {
      _showErrorSnackBar('Soyad alanı zorunludur');
      return false;
    }
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('E-posta alanı zorunludur');
      return false;
    }
    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',),.hasMatch(_emailController.text)) {
      _showErrorSnackBar('Geçerli bir e-posta adresi girin');
      return false;
    }
    if (_phoneController.text.isEmpty) {
      _showErrorSnackBar('Telefon alanı zorunludur');
      return false;
    }
    return true;
  }

  bool _validateVerification() {
    if (_verificationCodeController.text.length != 6) {
      _showErrorSnackBar('6 haneli doğrulama kodunu girin');
      return false;
    }
    return true;
  }

  bool _validatePassword() {
    if (_passwordController.text.length < 8) {
      _showErrorSnackBar('Şifre en az 8 karakter olmalı');
      return false;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Şifreler eşleşmiyor');
      return false;
    }
    if (!_acceptTerms) {
      _showErrorSnackBar('Kullanım şartlarını kabul etmelisiniz');
      return false;
    }
    return true;
  }

  Future<void> _sendVerificationCode() async {
    setState(() => _isLoading = true);
    try {
      // TODO: Send verification code via SMS/Email
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isVerificationSent = true);
      _showSuccessSnackBar('Doğrulama kodu gönderildi');
    } catch (e) {
      _showErrorSnackBar('Doğrulama kodu gönderilemedi');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleRegister() async {
    if (!_validateCurrentStep()) return;

    context.read<AuthBloc>().add(
          RegisterRequested(
            name: _nameController.text.trim(), surname: _surnameController.text.trim(), email: _emailController.text.trim(), phone: _phoneController.text.trim(), password: _passwordController.text,),);}

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message) backgroundColor: const Color(0xFFDC2626) behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),),);}

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message) backgroundColor: const Color(0xFF10B981) behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),),);}

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/main');
        } else if (state is AuthError) {
          _showErrorSnackBar(state.message);
        } else if (state is AuthLoading) {
          setState(() => _isLoading = true);
        } else if (state is Unauthenticated) {
          setState(() => _isLoading = false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC) appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF003875)), onPressed: () => context.go('/auth'),), title: const Text(
            'Kayıt Ol',
            style: TextStyle(
              color: Color(0xFF003875) fontWeight: FontWeight.bold,),),), body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24) child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress Indicator
                    _buildProgressIndicator(),

                    const SizedBox(height: 32)// Step Content
                    _buildStepContent(),

                    const SizedBox(height: 32)// Navigation Buttons
                    _buildNavigationButtons(),

                    const SizedBox(height: 20)],),),),),),),);}

  Widget _buildProgressIndicator() {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4) decoration: BoxDecoration(
              color: index <= _currentStep
                  ? const Color(0xFF003875)
                  : const Color(0xFFE2E8F0) borderRadius: BorderRadius.circular(2)),),);}),);}

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildVerificationStep();
      case 2:
        return _buildPasswordStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kişisel Bilgiler',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)),),const SizedBox(height: 8)const Text(
          'Hesabınızı oluşturmak için bilgilerinizi girin',
          style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),),const SizedBox(height: 32)// Name
        TextFormField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Ad',
            hintText: 'Adınızı girin',
            prefixIcon: Icon(Icons.person_outline, color: Color(0xFF64748B)),), validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ad alanı zorunludur';
            }
            return null;
          },),const SizedBox(height: 16)// Surname
        TextFormField(
          controller: _surnameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Soyad',
            hintText: 'Soyadınızı girin',
            prefixIcon: Icon(Icons.person_outline, color: Color(0xFF64748B)),), validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Soyad alanı zorunludur';
            }
            return null;
          },),const SizedBox(height: 16)// Email
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'E-posta',
            hintText: 'ornek@email.com',
            prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF64748B)),), validator: (value) {
            if (value == null || value.isEmpty) {
              return 'E-posta alanı zorunludur';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Geçerli bir e-posta adresi girin';
            }
            return null;
          },),const SizedBox(height: 16)// Phone
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11)],decoration: const InputDecoration(
            labelText: 'Telefon',
            hintText: '5XXXXXXXXX',
            prefixIcon: Icon(Icons.phone_outlined, color: Color(0xFF64748B)), prefixText: '+90 ',), validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Telefon alanı zorunludur';
            }
            if (value.length != 10) {
              return 'Geçerli bir telefon numarası girin';
            }
            return null;
          },),],);}

  Widget _buildVerificationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Doğrulama',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)),),const SizedBox(height: 8)Text(
          '${_phoneController.text.isNotEmpty ? "+90 ${_phoneController.text}" : _emailController.text} adresine gönderilen 6 haneli kodu girin',
          style: const TextStyle(fontSize: 16, color: Color(0xFF64748B)),),const SizedBox(height: 32)// Verification Code
        TextFormField(
          controller: _verificationCodeController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 6,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,), decoration: InputDecoration(
            labelText: 'Doğrulama Kodu',
            hintText: '000000',
            counterText: '',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),), validator: (value) {
            if (value == null || value.length != 6) {
              return '6 haneli kodu girin';
            }
            return null;
          },),const SizedBox(height: 24)// Resend Code
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Kod gelmedi mi?',
              style: TextStyle(color: Color(0xFF64748B)),),TextButton(
              onPressed: _isLoading ? null : _sendVerificationCode,
              child: Text(
                'Tekrar Gönder',
                style: TextStyle(
                  color: _isLoading ? Colors.grey : const Color(0xFF003875) fontWeight: FontWeight.w600,),),),],),],);}

  Widget _buildPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Şifre Oluştur',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)),),const SizedBox(height: 8)const Text(
          'Güçlü bir şifre belirleyin',
          style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),),const SizedBox(height: 32)// Password
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Şifre',
            hintText: 'En az 8 karakter',
            prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF64748B)),), validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Şifre alanı zorunludur';
            }
            if (value.length < 8) {
              return 'Şifre en az 8 karakter olmalı';
            }
            return null;
          },),const SizedBox(height: 16)// Confirm Password
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Şifre Tekrar',
            hintText: 'Şifrenizi tekrar girin',
            prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF64748B)),), validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Şifre tekrarı zorunludur';
            }
            if (value != _passwordController.text) {
              return 'Şifreler eşleşmiyor';
            }
            return null;
          },),const SizedBox(height: 24)// Terms and Conditions
        Container(
          padding: const EdgeInsets.all(16) decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC) borderRadius: BorderRadius.circular(12) border: Border.all(color: const Color(0xFFE2E8F0)),), child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() => _acceptTerms = value ?? false);
                    },
                    activeColor: const Color(0xFF003875)),Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Show terms and conditions
                      },
                      child: const Text(
                        'Kullanım Şartları ve Gizlilik Politikasını kabul ediyorum',
                        style: TextStyle(
                          color: Color(0xFF0F172A) fontSize: 14,),),),),],),const SizedBox(height: 8)Row(
                children: [
                  Checkbox(
                    value: _acceptMarketing,
                    onChanged: (value) {
                      setState(() => _acceptMarketing = value ?? false);
                    },
                    activeColor: const Color(0xFF003875)),const Expanded(
                    child: Text(
                      'Kampanya ve duyurular için iletişimime izin veriyorum (İsteğe bağlı)',
                      style: TextStyle(color: Color(0xFF64748B) fontSize: 14)),),],),],),),],);}

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        // Main Action Button
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading
                ? null
                : (_currentStep == 2 ? _handleRegister : _nextStep) style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003875) foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)), elevation: 0,), child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),),
                : Text(
                    _currentStep == 2 ? 'Kayıt Ol' : 'Devam Et',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,),),),),if (_currentStep > 0) ...[
          const SizedBox(height: 12)SizedBox(
            height: 48,
            child: TextButton(
              onPressed: _previousStep,
              child: const Text(
                'Geri Dön',
                style: TextStyle(
                  color: Color(0xFF003875) fontSize: 16,
                  fontWeight: FontWeight.w500,),),),),],],);}
}






