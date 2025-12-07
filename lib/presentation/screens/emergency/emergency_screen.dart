import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_constants.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600) vsync: this,);_scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut));_fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn));_animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _makeEmergencyCall(String number, String title) async {
    final phoneUri = Uri(scheme: 'tel', path: number);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showSnackBar('Arama yapılamıyor: $number');
      }
    } catch (e) {
      _showSnackBar('Arama hatası: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message) backgroundColor: const Color(AppConstants.secondaryColor) behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),),);}

  void _reportEmergency() {
    // TODO: Navigate to emergency reporting screen
    _showSnackBar('Acil durum ihbarı özelliği yakında eklenecek');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC) appBar: AppBar(
        backgroundColor: const Color(AppConstants.secondaryColor) elevation: 0,
        title: const Text(
          'ACİL DURUM',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,),), centerTitle: true,), body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24) child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Emergency Alert Banner
                  _buildEmergencyBanner(),

                  const SizedBox(height: 32)// Quick Emergency Buttons
                  _buildEmergencyButtons(),

                  const SizedBox(height: 32)// Emergency Contacts
                  _buildEmergencyContacts(),

                  const SizedBox(height: 32)// Emergency Instructions
                  _buildEmergencyInstructions(),

                  const SizedBox(height: 32)// Report Emergency Button
                  _buildReportButton(),],),),),),),);}

  Widget _buildEmergencyBanner() {
    return Container(
      padding: const EdgeInsets.all(20) decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(AppConstants.secondaryColor)Color(0xFF991B1B)],), borderRadius: BorderRadius.circular(16) boxShadow: [
          BoxShadow(
            color: const Color(AppConstants.secondaryColor).withValues(alpha: 0.3) blurRadius: 20,
            offset: const Offset(0, 8)),],), child: Column(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            size: 48,
            color: Colors.white,),const SizedBox(height: 12)const Text(
            'Acil Durumda\nHemen Yardım İsteyin',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,),),const SizedBox(height: 8)Text(
            'Hayatınız tehlikede ise hemen 112\'yi arayın',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9)),),],),);}

  Widget _buildEmergencyButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hızlı Arama',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)),),const SizedBox(height: 16)Row(
          children: [
            Expanded(
              child: _buildEmergencyButton(
                icon: Icons.local_police,
                label: 'POLİS\n155',
                color: const Color(0xFF1E40AF) number: AppConstants.policeNumber,),),const SizedBox(width: 16)Expanded(
              child: _buildEmergencyButton(
                icon: Icons.local_fire_department,
                label: 'İTFAİYE\n110',
                color: const Color(0xFFDC2626) number: AppConstants.fireNumber,),),],),const SizedBox(height: 16)_buildEmergencyButton(
          icon: Icons.emergency,
          label: 'ACİL YARDIM\n112',
          color: const Color(AppConstants.secondaryColor) number: AppConstants.emergencyNumber,
          isFullWidth: true,),],);}

  Widget _buildEmergencyButton({
    required IconData icon,
    required String label,
    required Color color,
    required String number,
    bool isFullWidth = false,},) {
    return SizedBox(
      height: 80,
      child: ElevatedButton(
        onPressed: () => _makeEmergencyCall(number, label.split('\n')[0]), style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)), elevation: 4,
          shadowColor: color.withValues(alpha: 0.3)), child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28)const SizedBox(width: 12)Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.2,),),],),),);}

  Widget _buildEmergencyContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tulpars Derneği İletişim',
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
              _buildContactItem(
                icon: Icons.phone,
                title: 'Acil Durum Hattı',
                subtitle: AppConstants.tulparsEmergency,
                color: const Color(AppConstants.primaryColor)),const Divider(height: 20)_buildContactItem(
                icon: Icons.location_on,
                title: 'Merkez',
                subtitle: 'Tulpars Derneği Genel Merkezi',
                color: const Color(0xFF10B981)),const Divider(height: 20)_buildContactItem(
                icon: Icons.web,
                title: 'Web Sitesi',
                subtitle: AppConstants.websiteUrl,
                color: const Color(0xFF3B82F6)),],),),],);}

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,},) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1) borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 20)),const SizedBox(width: 12)Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A)),),Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B)),),],),),IconButton(
          icon: Icon(Icons.arrow_forward_ios, size: 16, color: color) onPressed: () {
            if (title.contains('Hattı')) {
              _makeEmergencyCall(AppConstants.tulparsEmergency, 'Tulpars Acil');
            }
          },),],);}

  Widget _buildEmergencyInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acil Durum Talimatları',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInstructionItem(
                number: '1',
                title: 'Güvende Olduğunuzdan Emin Olun',
                description: 'Öncelikle kendi güvenliğiniz sağlayın.',),const SizedBox(height: 16)_buildInstructionItem(
                number: '2',
                title: 'Acil Yardım İsteyin',
                description: '112\'yi arayın ve durumunuzu açıklayın.',),const SizedBox(height: 16)_buildInstructionItem(
                number: '3',
                title: 'Tulpars\'a Bildirin',
                description: 'Mümkünse derneğimizi bilgilendirin.',),],),),],);}

  Widget _buildInstructionItem({
    required String number,
    required String title,
    required String description,},) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: Color(AppConstants.primaryColor) shape: BoxShape.circle,), child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,),),),),const SizedBox(width: 12)Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A)),),const SizedBox(height: 2)Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B) height: 1.4,),),],),),],);}

  Widget _buildReportButton() {
    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: _reportEmergency,
        icon: const Icon(Icons.report_problem,
            color: Color(AppConstants.secondaryColor)), label: const Text(
          'Acil Durum Bildir',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(AppConstants.secondaryColor)),), style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(AppConstants.secondaryColor)), shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),),),);}
}






