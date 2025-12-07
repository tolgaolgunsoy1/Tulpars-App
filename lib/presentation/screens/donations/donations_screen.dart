import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen>
    with TickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String _selectedPaymentMethod = 'credit_card';
  String _selectedFrequency = 'one_time';
  bool _isAnonymous = false;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _presetAmounts = [
    {'amount': 50, 'label': '₺50'},
    {'amount': 100, 'label': '₺100'},
    {'amount': 250, 'label': '₺250'},
    {'amount': 500, 'label': '₺500'},];@override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _selectPresetAmount(int amount) {
    setState(() {
      _amountController.text = amount.toString();
    });
  }

  void _processDonation() async {
    if (_amountController.text.isEmpty) {
      _showSnackBar('Lütfen bağış miktarını girin');
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showSnackBar('Geçerli bir bağış miktarı girin');
      return;
    }

    if (!_isAnonymous && _nameController.text.isEmpty) {
      _showSnackBar('Ad Soyad alanını doldurun veya anonim olarak bağış yapın');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implement actual payment processing
      await Future.delayed(const Duration(seconds: 2));

      _showSuccessDialog(amount);
    } catch (e) {
      _showSnackBar('Bağış işlemi sırasında hata oluştu: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog(double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), title: const Text(
          'Bağışınız İçin Teşekkür Ederiz!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(AppConstants.primaryColor) fontWeight: FontWeight.bold,),), content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(AppConstants.successColor) size: 48,),const SizedBox(height: 16)Text(
              '₺${amount.toStringAsFixed(0)} tutarındaki bağışınız başarıyla alındı.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16)),const SizedBox(height: 8)const Text(
              'Tulpars Derneği olarak topluma hizmet etmek için çalışmalarımızı sürdürüyoruz.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),),],), actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), child: const Text('Tamam'),),],),);}

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
          'Bağış Yap',
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

              const SizedBox(height: 32)// Amount Selection
              _buildAmountSection(),

              const SizedBox(height: 32)// Payment Method
              _buildPaymentMethodSection(),

              const SizedBox(height: 32)// Frequency
              _buildFrequencySection(),

              const SizedBox(height: 32)// Donor Information
              _buildDonorInfoSection(),

              const SizedBox(height: 32)// Donate Button
              _buildDonateButton(),

              const SizedBox(height: 24)// Impact Information
              _buildImpactInfo(),],),),),);}

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
            Icons.volunteer_activism,
            size: 48,
            color: Colors.white,),const SizedBox(height: 16)const Text(
            'Desteklerinizle\nDaha Güçlü Bir Toplum',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,),),const SizedBox(height: 8)Text(
            'Bağışlarınızla arama-kurtarma operasyonlarına, eğitim programlarına ve sosyal yardım çalışmalarına destek oluyorsunuz.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9) height: 1.4,),),],),);}

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bağış Miktarı',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)),),const SizedBox(height: 16)// Preset Amounts
        Row(
          children: _presetAmounts.map((preset) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4) child: OutlinedButton(
                  onPressed: () => _selectPresetAmount(preset['amount']), style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                        color: Color(AppConstants.primaryColor)), shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(vertical: 12)), child: Text(
                    preset['label'],
                    style: const TextStyle(
                      color: Color(AppConstants.primaryColor) fontWeight: FontWeight.w600,),),),),);}).toList(),),const SizedBox(height: 16)// Custom Amount
        TextFormField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly]decoration: InputDecoration(
            labelText: 'Diğer Tutar (₺)',
            hintText: 'Bağış miktarını girin',
            prefixIcon:
                const Icon(Icons.attach_money, color: Color(0xFF64748B)), border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)), filled: true,
            fillColor: Colors.white,), validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Bağış miktarı gerekli';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Geçerli bir miktar girin';
            }
            return null;
          },),],);}

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ödeme Yöntemi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)),),const SizedBox(height: 16)Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12) boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05) blurRadius: 10,
                offset: const Offset(0, 2)),],), child: Column(
            children: [
              _buildPaymentOption(
                value: 'credit_card',
                title: 'Kredi Kartı',
                subtitle: 'Visa, Mastercard, American Express',
                icon: Icons.credit_card,),const Divider(height: 1)_buildPaymentOption(
                value: 'bank_transfer',
                title: 'Havale/EFT',
                subtitle: 'Banka hesabımıza doğrudan transfer',
                icon: Icons.account_balance,),const Divider(height: 1)_buildPaymentOption(
                value: 'mobile_payment',
                title: 'Mobil Ödeme',
                subtitle: 'Mobil cüzdanlar ile ödeme',
                icon: Icons.phone_android,),],),),],);}

  Widget _buildPaymentOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,},) {
    final isSelected = _selectedPaymentMethod == value;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = value) child: Padding(
        padding: const EdgeInsets.all(16) child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(AppConstants.primaryColor)
                        .withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8)), child: Icon(
                icon,
                color: isSelected
                    ? const Color(AppConstants.primaryColor)
                    : Colors.grey.shade600,),),const SizedBox(width: 12)Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(AppConstants.primaryColor)
                          : const Color(0xFF0F172A)),),Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B)),),],),),Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) =>
                  setState(() => _selectedPaymentMethod = value!), fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return const Color(AppConstants.primaryColor);
                  }
                  return Colors.grey.shade400;
                }),),],),),);}

  Widget _buildFrequencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bağış Sıklığı',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)),),const SizedBox(height: 16)Row(
          children: [
            Expanded(
              child: _buildFrequencyOption('one_time', 'Tek Seferlik'),),const SizedBox(width: 12)Expanded(
              child: _buildFrequencyOption('monthly', 'Aylık'),),],),],);}

  Widget _buildFrequencyOption(String value, String label) {
    final isSelected = _selectedFrequency == value;
    return InkWell(
      onTap: () => setState(() => _selectedFrequency = value) child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12) decoration: BoxDecoration(
          color: isSelected
              ? const Color(AppConstants.primaryColor)
              : Colors.white,
          borderRadius: BorderRadius.circular(8) border: Border.all(
            color: isSelected
                ? const Color(AppConstants.primaryColor)
                : Colors.grey.shade300,),), child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF0F172A)),),),);}

  Widget _buildDonorInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bağışçı Bilgileri',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)),),const SizedBox(height: 16)// Anonymous Checkbox
        Row(
          children: [
            Checkbox(
              value: _isAnonymous,
              onChanged: (value) =>
                  setState(() => _isAnonymous = value ?? false) activeColor: const Color(AppConstants.primaryColor)),const Text(
              'Anonim olarak bağış yapmak istiyorum',
              style: TextStyle(color: Color(0xFF64748B)),),],),const SizedBox(height: 16)// Name Field (if not anonymous)
        if (!_isAnonymous)
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Ad Soyad',
              hintText: 'Adınızı ve soyadınızı girin',
              prefixIcon: Icon(Icons.person_outline, color: Color(0xFF64748B)),), validator: (value) {
              if (!_isAnonymous && (value == null || value.isEmpty)) {
                return 'Ad Soyad gerekli';
              }
              return null;
            },),if (!_isAnonymous) const SizedBox(height: 16)// Message Field
        TextFormField(
          controller: _messageController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Mesajınız (İsteğe bağlı)',
            hintText: 'Bağışınızla ilgili bir mesaj bırakın...',
            prefixIcon: Icon(Icons.message_outlined, color: Color(0xFF64748B)),),),],);}

  Widget _buildDonateButton() {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _processDonation,
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
            : Text(
                _amountController.text.isNotEmpty
                    ? '₺${_amountController.text} Bağış Yap'
                    : 'Bağış Yap',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,),),),);}

  Widget _buildImpactInfo() {
    return Container(
      padding: const EdgeInsets.all(20) decoration: BoxDecoration(
        color: const Color(AppConstants.successColor).withValues(alpha: 0.1) borderRadius: BorderRadius.circular(12) border: Border.all(
            color:
                const Color(AppConstants.successColor).withValues(alpha: 0.2)),), child: const Column(
        children: [
          Icon(
            Icons.trending_up,
            color: Color(AppConstants.successColor) size: 32,),SizedBox(height: 12)Text(
            'Bağışlarınızın Etkisi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(AppConstants.successColor)),),SizedBox(height: 8)Text(
            '₺100 bağışınızla bir kişinin 3 günlük gıda ihtiyacını karşılayabiliriz.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF0F172A) height: 1.4,),),],),);}
}






