import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedMembershipType = 'active';
  bool _acceptTerms = false;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _membershipTypes = [
    {
      'id': 'active',
      'title': 'Aktif Üye',
      'description':
          'Operasyonlara katılma, eğitimlere katılma, oy kullanma hakkı',
      'fee': 100,
      'benefits': [
        'Arama-kurtarma operasyonlarına katılma',
        'İlk yardım ve sivil savunma eğitimleri',
        'Genel kurul toplantılarında oy kullanma',
        'Dernek etkinliklerine katılım',
        'Üye kimlik kartı',],},{
      'id': 'supportive',
      'title': 'Destekleyici Üye',
      'description': 'Maddi destek sağlama, etkinliklere katılma',
      'fee': 50,
      'benefits': [
        'Dernek etkinliklerine katılım',
        'Duyurular ve haberlerden haberdar olma',
        'Vergi muafiyeti avantajı',
        'Destekçi sertifikası',],},{
      'id': 'youth',
      'title': 'Gençlik Üye',
      'description': '18-25 yaş arası gençler için özel üyelik',
      'fee': 25,
      'benefits': [
        'Gençlik spor faaliyetlerine katılım',
        'Eğitim programlarına öncelikli erişim',
        'Sosyal sorumluluk projelerine katılma',
        'Gençlik kimlik kartı',],},];@override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _selectMembershipType(String typeId) {
    setState(() {
      _selectedMembershipType = typeId;
    });
  }

  void _submitMembership() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Implement membership registration
      await Future.delayed(const Duration(seconds: 2));

      _showSuccessDialog();
    } catch (e) {
      _showSnackBar('Üyelik başvurusu sırasında hata oluştu: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateForm() {
    if (_nameController.text.isEmpty) {
      _showSnackBar('Ad alanı zorunludur');
      return false;
    }
    if (_surnameController.text.isEmpty) {
      _showSnackBar('Soyad alanı zorunludur');
      return false;
    }
    if (_emailController.text.isEmpty) {
      _showSnackBar('E-posta alanı zorunludur');
      return false;
    }
    if (_phoneController.text.isEmpty) {
      _showSnackBar('Telefon alanı zorunludur');
      return false;
    }
    if (_addressController.text.isEmpty) {
      _showSnackBar('Adres alanı zorunludur');
      return false;
    }
    if (!_acceptTerms) {
      _showSnackBar('Üyelik şartlarını kabul etmelisiniz');
      return false;
    }
    return true;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), title: const Text(
          'Üyelik Başvurunuz Alındı!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(AppConstants.primaryColor) fontWeight: FontWeight.bold,),), content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              color: Color(AppConstants.successColor) size: 48,),SizedBox(height: 16)Text(
              'Üyelik başvurunuz başarıyla alındı. Başvurunuz incelendikten sonra size bilgi verilecektir.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16)),SizedBox(height: 8)Text(
              'Bu süreç genellikle 3-5 iş günü sürer.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B)),),],), actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/main');
            },
            child: const Text('Ana Sayfaya Dön'),),],),);}

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message) backgroundColor: const Color(AppConstants.secondaryColor) behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),),);}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC) appBar: AppBar(
        backgroundColor: const Color(AppConstants.primaryColor) elevation: 0,
        title: const Text(
          'Üye Ol',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,),), centerTitle: true,), body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24) child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 32)// Membership Types
              _buildMembershipTypes(),

              const SizedBox(height: 32)// Personal Information
              _buildPersonalInfo(),

              const SizedBox(height: 32)// Terms and Conditions
              _buildTermsSection(),

              const SizedBox(height: 32)// Submit Button
              _buildSubmitButton(),

              const SizedBox(height: 24)// Info Section
              _buildInfoSection(),],),),),);}

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24) decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(AppConstants.primaryColor)Color(AppConstants.primaryLightColor)],), borderRadius: BorderRadius.circular(16) boxShadow: [
          BoxShadow(
            color:
                const Color(AppConstants.primaryColor).withValues(alpha: 0.3) blurRadius: 20,
            offset: const Offset(0, 8)),],), child: Column(
        children: [
          const Icon(
            Icons.group_add,
            size: 48,
            color: Colors.white,),const SizedBox(height: 16)const Text(
            'Tulpars Ailesine Katılın',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,),),const SizedBox(height: 8)Text(
            'Sivil savunma, arama-kurtarma ve sosyal dayanışma çalışmalarımıza destek olmak için üye olun.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9) height: 1.4,),),],),);}

  Widget _buildMembershipTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Üyelik Türü',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)),),const SizedBox(height: 16)..._membershipTypes.map(_buildMembershipTypeCard)],);}

  Widget _buildMembershipTypeCard(Map<String, dynamic> type) {
    final isSelected = _selectedMembershipType == type['id'];
    return Container(
      margin: const EdgeInsets.only(bottom: 12) decoration: BoxDecoration(
        color: isSelected
            ? const Color(AppConstants.primaryColor).withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12) border: Border.all(
          color: isSelected
              ? const Color(AppConstants.primaryColor)
              : Colors.grey.shade300,
          width: isSelected ? 2 : 1,), boxShadow: isSelected
             [
                BoxShadow(
                  color: const Color(AppConstants.primaryColor)
                      .withValues(alpha: 0.2) blurRadius: 8,
                  offset: const Offset(0, 4)),],
            : null,), child: InkWell(
        onTap: () => _selectMembershipType(type['id']), borderRadius: BorderRadius.circular(12) child: Padding(
          padding: const EdgeInsets.all(16) child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          type['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? const Color(AppConstants.primaryColor)
                                : const Color(0xFF0F172A)),),const SizedBox(height: 4)Text(
                          type['description'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B)),),],),),Radio<String>(
                    value: type['id'],
                    groupValue: _selectedMembershipType,
                    onChanged: (value) => _selectMembershipType(value!), fillColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return const Color(AppConstants.primaryColor);
                        }
                        return Colors.grey.shade400;
                      }),),],),const SizedBox(height: 12)Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6) decoration: BoxDecoration(
                  color: const Color(AppConstants.accentColor)
                      .withValues(alpha: 0.1) borderRadius: BorderRadius.circular(20)), child: Text(
                  'Yıllık Aidat: ₺${type['fee']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(AppConstants.accentColor)),),),const SizedBox(height: 12)const Text(
                'Avantajlar:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A)),),const SizedBox(height: 8)...type['benefits'].map<Widget>((benefit) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4) child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Color(AppConstants.successColor)),const SizedBox(width: 8)Expanded(
                        child: Text(
                          benefit,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B)),),),],),);}),],),),),);}

  Widget _buildPersonalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kişisel Bilgiler',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)),),const SizedBox(height: 16)Container(
          padding: const EdgeInsets.all(20) decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12) boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05) blurRadius: 10,
                offset: const Offset(0, 2)),],), child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Ad',
                        hintText: 'Adınızı girin',
                        prefixIcon: Icon(Icons.person_outline,
                            color: Color(0xFF64748B)),),),),const SizedBox(width: 12)Expanded(
                    child: TextFormField(
                      controller: _surnameController,
                      decoration: const InputDecoration(
                        labelText: 'Soyad',
                        hintText: 'Soyadınızı girin',
                        prefixIcon: Icon(Icons.person_outline,
                            color: Color(0xFF64748B)),),),),],),const SizedBox(height: 16)TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  hintText: 'ornek@email.com',
                  prefixIcon:
                      Icon(Icons.email_outlined, color: Color(0xFF64748B)),),),const SizedBox(height: 16)TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  hintText: '5XXXXXXXXX',
                  prefixIcon:
                      Icon(Icons.phone_outlined, color: Color(0xFF64748B)), prefixText: '+90 ',),),const SizedBox(height: 16)TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Adres',
                  hintText: 'Tam adresinizi girin',
                  prefixIcon: Icon(Icons.location_on_outlined,
                      color: Color(0xFF64748B)),),),],),),],);}

  Widget _buildTermsSection() {
    return Container(
      padding: const EdgeInsets.all(16) decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12) boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05) blurRadius: 10,
            offset: const Offset(0, 2)),],), child: Row(
        children: [
          Checkbox(
            value: _acceptTerms,
            onChanged: (value) => setState(() => _acceptTerms = value ?? false) activeColor: const Color(AppConstants.primaryColor)),Expanded(
            child: GestureDetector(
              onTap: () {
                // TODO: Show terms and conditions
              },
              child: const Text(
                'Üyelik şartlarını ve dernek tüzüğünü kabul ediyorum',
                style: TextStyle(
                  color: Color(0xFF0F172A) fontSize: 14,),),),),],),);}

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitMembership,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppConstants.primaryColor) foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)), elevation: 0,), child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),),
            : const Text(
                'Üyelik Başvurusu Yap',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,),),),);}

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20) decoration: BoxDecoration(
        color: const Color(AppConstants.successColor).withValues(alpha: 0.1) borderRadius: BorderRadius.circular(12) border: Border.all(
            color:
                const Color(AppConstants.successColor).withValues(alpha: 0.2)),), child: const Column(
        children: [
          Icon(
            Icons.info,
            color: Color(AppConstants.successColor) size: 32,),SizedBox(height: 12)Text(
            'Üyelik Süreci',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(AppConstants.successColor)),),SizedBox(height: 8)Text(
            'Başvurunuz yönetim kurulumuz tarafından incelendikten sonra onaylanır ve üye kimliğiniz hazırlanır.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF0F172A) height: 1.4,),),],),);}
}






