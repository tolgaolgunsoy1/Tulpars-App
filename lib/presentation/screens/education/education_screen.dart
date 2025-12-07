import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _trainingPrograms = [
    {
      'id': 'first_aid',
      'title': 'İlk Yardım Eğitimi',
      'description': 'Temel ilk yardım bilgileri ve uygulamalı eğitim',
      'icon': Icons.medical_services,
      'color': const Color(0xFFDC2626)'duration': '16 Saat',
      'level': 'Başlangıç',
      'instructor': 'Dr. Ahmet Yılmaz',
      'schedule': 'Hafta sonları 09:00-17:00',
      'capacity': 25,
      'enrolled': 18,
      'upcoming': '15-16 Aralık 2024',
      'topics': [
        'Temel yaşam desteği',
        'Yaralanma vakaları',
        'Acil durum müdahalesi',
        'CPR uygulaması',],},{
      'id': 'search_rescue',
      'title': 'Arama Kurtarma Eğitimi',
      'description': 'Doğal afetlerde arama kurtarma teknikleri',
      'icon': Icons.search,
      'color': const Color(0xFFF59E0B)'duration': '24 Saat',
      'level': 'Orta',
      'instructor': 'Komutan Mehmet Kaya',
      'schedule': 'Hafta içi akşamları',
      'capacity': 20,
      'enrolled': 15,
      'upcoming': '20-22 Aralık 2024',
      'topics': [
        'Harita okuma',
        'Çadır kurma',
        'İletişim teknikleri',
        'Kurtarma operasyonları',],},{
      'id': 'fire_safety',
      'title': 'Yangın Güvenliği',
      'description': 'Yangın önleme ve müdahale eğitimi',
      'icon': Icons.local_fire_department,
      'color': const Color(0xFFEF4444)'duration': '12 Saat',
      'level': 'Başlangıç',
      'instructor': 'İtfaiye Uzmanı Ayşe Demir',
      'schedule': 'Cumartesi günleri',
      'capacity': 30,
      'enrolled': 22,
      'upcoming': '28 Aralık 2024',
      'topics': [
        'Yangın söndürme',
        'Tahliye prosedürleri',
        'Önleme tedbirleri',
        'Ekipman kullanımı',],},{
      'id': 'youth_leadership',
      'title': 'Gençlik Liderlik Eğitimi',
      'description': 'Liderlik becerileri ve toplumsal sorumluluk',
      'icon': Icons.psychology,
      'color': const Color(0xFF8B5CF6)'duration': '20 Saat',
      'level': 'İleri',
      'instructor': 'Sosyal Hizmet Uzmanı Fatma Öztürk',
      'schedule': 'Pazar günleri',
      'capacity': 15,
      'enrolled': 12,
      'upcoming': '5-6 Ocak 2025',
      'topics': [
        'İletişim becerileri',
        'Takım çalışması',
        'Proje yönetimi',
        'Toplumsal hizmet',],},];final List<Map<String, dynamic>> _certificates = [
    {
      'title': 'İlk Yardım Sertifikası',
      'description': 'Uluslararası Kızılhaç onaylı sertifika',
      'icon': Icons.verified,
      'color': const Color(0xFFDC2626)'validity': '3 Yıl',},{
      'title': 'Arama Kurtarma Sertifikası',
      'description': 'AFAD onaylı profesyonel sertifika',
      'icon': Icons.military_tech,
      'color': const Color(0xFFF59E0B)'validity': '5 Yıl',},{
      'title': 'Yangın Güvenliği Sertifikası',
      'description': 'İtfaiye Bakanlığı onaylı',
      'icon': Icons.local_fire_department,
      'color': const Color(0xFFEF4444)'validity': '2 Yıl',},];@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC) appBar: AppBar(
        backgroundColor: const Color(AppConstants.primaryColor) elevation: 0,
        title: const Text(
          'Eğitimler',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,),), centerTitle: true,), body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24) child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),

              const SizedBox(height: 32)// Training Programs
              _buildTrainingPrograms(),

              const SizedBox(height: 32)// Certificates
              _buildCertificates(),

              const SizedBox(height: 32)// Registration Info
              _buildRegistrationInfo(),],),),),);}

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24) decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(AppConstants.primaryColor)Color(AppConstants.primaryLightColor)],), borderRadius: BorderRadius.circular(16) boxShadow: [
          BoxShadow(
            color: const Color(AppConstants.primaryColor).withValues(alpha: 0.3) blurRadius: 20,
            offset: const Offset(0, 8)),],), child: Column(
        children: [
          const Icon(
            Icons.school,
            size: 48,
            color: Colors.white,),const SizedBox(height: 16)const Text(
            'Eğitim Programlarımız',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,),),const SizedBox(height: 8)Text(
            'Sivil savunma, arama kurtarma ve toplumsal hizmet eğitimleri ile toplumu güçlendiriyoruz.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9) height: 1.4,),),],),);}

  Widget _buildTrainingPrograms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eğitim Programları',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)),),const SizedBox(height: 16)..._trainingPrograms.map(_buildProgramCard)],);}

  Widget _buildProgramCard(Map<String, dynamic> program) {
    final progress = program['enrolled'] / program['capacity'];
    final isFull = progress >= 1.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16) padding: const EdgeInsets.all(20) decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16) boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05) blurRadius: 10,
            offset: const Offset(0, 2)),],), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: program['color'].withValues(alpha: 0.1) borderRadius: BorderRadius.circular(12)), child: Icon(
                  program['icon'],
                  color: program['color'],
                  size: 28,),),const SizedBox(width: 16)Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A)),),Text(
                      program['description'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B)),),],),),],),const SizedBox(height: 16)// Program Details
          Row(
            children: [
              _buildDetailChip(Icons.schedule, program['duration']),
              const SizedBox(width: 8)_buildDetailChip(Icons.trending_up, program['level']),
              const SizedBox(width: 8)_buildDetailChip(
                  Icons.person, program['instructor'].split(' ')[0]),],),const SizedBox(height: 12)// Schedule and Capacity
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(Icons.calendar_today, program['schedule']),),Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${program['enrolled']}/${program['capacity']} Katılımcı',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B) fontWeight: FontWeight.w500,),),const SizedBox(height: 4)LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(program['color']),),],),),],),const SizedBox(height: 16)// Upcoming Session
          Container(
            padding: const EdgeInsets.all(12) decoration: BoxDecoration(
              color: const Color(AppConstants.accentColor).withValues(alpha: 0.1) borderRadius: BorderRadius.circular(8) border: Border.all(
                color: const Color(AppConstants.accentColor).withValues(alpha: 0.2)),), child: Row(
              children: [
                const Icon(
                  Icons.event_available,
                  color: Color(AppConstants.accentColor) size: 20,),const SizedBox(width: 8)Expanded(
                  child: Text(
                    'Sonraki Oturum: ${program['upcoming']}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(AppConstants.accentColor)),),),],),),const SizedBox(height: 16)// Topics
          const Text(
            'Konular:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A)),),const SizedBox(height: 8)Wrap(
            spacing: 8,
            runSpacing: 4,
            children: program['topics'].map<Widget>((topic) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4) decoration: BoxDecoration(
                  color: program['color'].withValues(alpha: 0.1) borderRadius: BorderRadius.circular(12)), child: Text(
                  topic,
                  style: TextStyle(
                    fontSize: 10,
                    color: program['color'],
                    fontWeight: FontWeight.w500,),),);}).toList(),),const SizedBox(height: 16)// Register Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: isFull
                  ? null
                  : () {
                      // TODO: Register for training
                      _showRegistrationDialog(program);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isFull ? Colors.grey : program['color'],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)), elevation: 0,), child: Text(
                isFull ? 'Kontenjan Dolu' : 'Kayıt Ol',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,),),),),],),);}

  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4) decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12)), child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade600)const SizedBox(width: 4)Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF64748B) fontWeight: FontWeight.w500,),),],),);}

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF64748B)),const SizedBox(width: 4)Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B)),),),],);}

  Widget _buildCertificates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Sertifikalarımız',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A)),),const SizedBox(height: 16)Container(
          padding: const EdgeInsets.all(20) decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16) boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05) blurRadius: 10,
                offset: const Offset(0, 2)),],), child: Column(
            children: _certificates.map((cert) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16) padding: const EdgeInsets.all(16) decoration: BoxDecoration(
                  color: cert['color'].withValues(alpha: 0.1) borderRadius: BorderRadius.circular(12) border: Border.all(
                    color: cert['color'].withValues(alpha: 0.2)),), child: Row(
                  children: [
                    Icon(
                      cert['icon'],
                      color: cert['color'],
                      size: 32,),const SizedBox(width: 16)Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cert['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: cert['color'],),),const SizedBox(height: 4)Text(
                            cert['description'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B)),),const SizedBox(height: 4)Text(
                            'Geçerlilik: ${cert['validity']}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF64748B) fontStyle: FontStyle.italic,),),],),),],),);}).toList(),),),],);}

  Widget _buildRegistrationInfo() {
    return Container(
      padding: const EdgeInsets.all(24) decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(AppConstants.successColor)Color(0xFF059669)],), borderRadius: BorderRadius.circular(16) boxShadow: [
          BoxShadow(
            color: const Color(AppConstants.successColor).withValues(alpha: 0.3) blurRadius: 20,
            offset: const Offset(0, 8)),],), child: Column(
        children: [
          const Icon(
            Icons.contact_support,
            size: 48,
            color: Colors.white,),const SizedBox(height: 16)const Text(
            'Eğitimlere Kayıt',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,),),const SizedBox(height: 8)const Text(
            'Eğitim programlarımız hakkında detaylı bilgi ve kayıt için bizimle iletişime geçin.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.4,),),const SizedBox(height: 20)SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                // TODO: Navigate to contact or show contact info
                _showSnackBar('İletişim bilgileri: info@tulpars.org.tr');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white) shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),), child: const Text(
                'İletişime Geç',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,),),),),],),);}

  void _showRegistrationDialog(Map<String, dynamic> program) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), title: Text(
          '${program['title']} Eğitimi',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(AppConstants.primaryColor) fontWeight: FontWeight.bold,),), content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              program['icon'],
              color: program['color'],
              size: 48,),const SizedBox(height: 16)const Text(
              'Bu eğitime kayıt olmak istediğinizden emin misiniz?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16)),const SizedBox(height: 8)Text(
              'Tarih: ${program['upcoming']}\nEğitmen: ${program['instructor']}\nSüre: ${program['duration']}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B)),),],), actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), child: const Text('İptal'),),ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBar(
                  '${program['title']} eğitimine kayıt başvurunuz alındı',);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: program['color'],), child: const Text('Kayıt Ol'),),],),);}

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message) backgroundColor: const Color(AppConstants.successColor) behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),),);}
}






