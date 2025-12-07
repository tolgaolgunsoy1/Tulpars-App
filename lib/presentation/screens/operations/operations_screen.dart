import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';

class OperationsScreen extends StatefulWidget {
  const OperationsScreen({super.key});

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen>
    with TickerProviderStateMixin {
  final List<String> _operationTypes = [
    'Tümü',
    'Arama-Kurtarma',
    'Yangın',
    'Trafik Kazası',
    'Doğal Afet',
    'Sosyal Yardım',];String _selectedType = 'Tümü';

  final List<Map<String, dynamic>> _operations = [
    {
      'id': '1',
      'title': 'Hatay Deprem Arama Kurtarma',
      'description':
          '6 Şubat depreminde Hatay bölgesinde yürütülen arama kurtarma çalışmaları',
      'type': 'Arama-Kurtarma',
      'status': 'active',
      'startDate': DateTime(2024, 11, 15)'location': 'Hatay Merkez',
      'teamSize': 25,
      'coordinator': 'Ahmet Kaya',
      'progress': 0.75,
      'updates': [
        {'date': DateTime(2024, 11, 15)'message': 'Operasyon başlatıldı'},
        {'date': DateTime(2024, 11, 18)'message': '3 vatandaş kurtarıldı'},
        {'date': DateTime(2024, 11, 20)'message': 'Yeni bölgeye geçildi'},],'priority': 'high',},{
      'id': '2',
      'title': 'İzmir Yangın Müdahalesi',
      'description': 'İş yeri yangınına müdahale ve söndürme çalışmaları',
      'type': 'Yangın',
      'status': 'completed',
      'startDate': DateTime(2024, 10, 22)'endDate': DateTime(2024, 10, 22)'location': 'İzmir Bornova',
      'teamSize': 8,
      'coordinator': 'Mehmet Demir',
      'progress': 1.0,
      'updates': [
        {
          'date': DateTime(2024, 10, 22)'message': 'Yangın kontrol altına alındı',
        },
        {
          'date': DateTime(2024, 10, 22)'message': 'Operasyon başarıyla tamamlandı',
        }],'priority': 'high',},{
      'id': '3',
      'title': 'İstanbul Trafik Kazası',
      'description': 'Otoyol kazasında yaralılara müdahale',
      'type': 'Trafik Kazası',
      'status': 'completed',
      'startDate': DateTime(2024, 10, 15)'endDate': DateTime(2024, 10, 15)'location': 'İstanbul TEM Otoyolu',
      'teamSize': 5,
      'coordinator': 'Ayşe Yıldız',
      'progress': 1.0,
      'updates': [
        {'date': DateTime(2024, 10, 15)'message': 'İlk müdahale yapıldı'},
        {
          'date': DateTime(2024, 10, 15)'message': 'Yaralılar hastaneye sevk edildi',
        }],'priority': 'medium',},{
      'id': '4',
      'title': 'Sakarya Sel Baskını',
      'description':
          'Sel baskını sonrası evlere su tahliye ve yardım çalışmaları',
      'type': 'Doğal Afet',
      'status': 'active',
      'startDate': DateTime(2024, 11, 10)'location': 'Sakarya Adapazarı',
      'teamSize': 15,
      'coordinator': 'Hasan Öztürk',
      'progress': 0.6,
      'updates': [
        {
          'date': DateTime(2024, 11, 10)'message': 'Tahliye çalışmaları başladı',
        },
        {
          'date': DateTime(2024, 11, 12)'message': '50 aileye yardım ulaştırıldı',
        }],'priority': 'high',},{
      'id': '5',
      'title': 'Gıda Dağıtım Kampanyası',
      'description':
          'Ramazan ayında ihtiyaç sahibi ailelere gıda paketi dağıtımı',
      'type': 'Sosyal Yardım',
      'status': 'completed',
      'startDate': DateTime(2024, 9, 1)'endDate': DateTime(2024, 9, 30)'location': 'İstanbul Anadolu Yakası',
      'teamSize': 12,
      'coordinator': 'Fatma Kara',
      'progress': 1.0,
      'updates': [
        {'date': DateTime(2024, 9, 15)'message': '200 paket dağıtıldı'},
        {
          'date': DateTime(2024, 9, 30)'message': 'Kampanya başarıyla tamamlandı',
        }],'priority': 'medium',},];List<Map<String, dynamic>> get _filteredOperations {
    if (_selectedType == 'Tümü') return _operations;
    return _operations.where((op) => op['type'] == _selectedType).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC) appBar: AppBar(
        backgroundColor: const Color(AppConstants.primaryColor) elevation: 0,
        title: const Text(
          'Operasyonlar',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,),), centerTitle: true,), body: SafeArea(
        child: Column(
          children: [
            // Type Filter
            _buildTypeFilter(),

            // Operations List
            Expanded(
              child: _filteredOperations.isEmpty
                  ? _buildEmptyState()
                  : _buildOperationsList(),),],),),);}

  Widget _buildTypeFilter() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 16) child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24) itemCount: _operationTypes.length,
        itemBuilder: (context, index) {
          final type = _operationTypes[index];
          final isSelected = type == _selectedType;
          return Container(
            margin: const EdgeInsets.only(right: 12) child: FilterChip(
              label: Text(type) selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedType = type;
                });
              },
              backgroundColor: Colors.white,
              selectedColor:
                  const Color(AppConstants.primaryColor).withValues(alpha: 0.1) checkmarkColor: const Color(AppConstants.primaryColor) labelStyle: TextStyle(
                color: isSelected
                    ? const Color(AppConstants.primaryColor)
                    : const Color(0xFF64748B) fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,), shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20) side: BorderSide(
                  color: isSelected
                      ? const Color(AppConstants.primaryColor)
                      : Colors.grey.shade300,),),),);},),);}

  Widget _buildOperationsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24) itemCount: _filteredOperations.length,
      itemBuilder: (context, index) {
        final operation = _filteredOperations[index];
        return _buildOperationCard(operation);
      },);}

  Widget _buildOperationCard(Map<String, dynamic> operation) {
    final isActive = operation['status'] == 'active';
    final priority = operation['priority'];
    Color priorityColor;
    switch (priority) {
      case 'high':
        priorityColor = const Color(0xFFDC2626);
        break;
      case 'medium':
        priorityColor = const Color(0xFFF59E0B);
        break;
      default:
        priorityColor = const Color(0xFF10B981);
    }

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
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF10B981) : Colors.grey,
                  shape: BoxShape.circle,),),const SizedBox(width: 8)Text(
                isActive ? 'Aktif' : 'Tamamlandı',
                style: TextStyle(
                  color: isActive ? const Color(0xFF10B981) : Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,),),const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4) decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.1) borderRadius: BorderRadius.circular(12)), child: Text(
                  priority == 'high'
                      ? 'Yüksek'
                      : priority == 'medium'
                          ? 'Orta'
                          : 'Düşük',
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,),),),],),const SizedBox(height: 12)// Title
          Text(
            operation['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A)),),const SizedBox(height: 8)// Description
          Text(
            operation['description'],
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B) height: 1.4,),),const SizedBox(height: 16)// Details
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  Icons.location_on,
                  operation['location'],),),Expanded(
                child: _buildDetailItem(
                  Icons.people,
                  '${operation['teamSize']} Kişi',),),],),const SizedBox(height: 12)Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  Icons.person,
                  operation['coordinator'],),),Expanded(
                child: _buildDetailItem(
                  Icons.calendar_today,
                  DateFormat('dd.MM.yyyy').format(operation['startDate']),),),],),const SizedBox(height: 16)// Progress Bar (for active operations)
          if (isActive) ...[
            const Text(
              'İlerleme',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A)),),const SizedBox(height: 8)LinearProgressIndicator(
              value: operation['progress'],
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(AppConstants.primaryColor)),),const SizedBox(height: 4)Text(
              '%${(operation['progress'] * 100).round()}',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B)),),],const SizedBox(height: 16)// Updates
          if (operation['updates'] != null &&
              operation['updates'].isNotEmpty) ...[
            const Text(
              'Son Güncellemeler',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A)),),const SizedBox(height: 8)...operation['updates'].take(2).map<Widget>((update) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4) child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '• ',
                      style: TextStyle(
                        color: Color(0xFF64748B) fontSize: 12,),),Expanded(
                      child: Text(
                        update['message'],
                        style: const TextStyle(
                          color: Color(0xFF64748B) fontSize: 12,),),),],),);}),],const SizedBox(height: 16)// Action Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => _showOperationDetails(operation) style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(AppConstants.primaryColor)), shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),), child: const Text(
                'Detayları Gör',
                style: TextStyle(
                  color: Color(AppConstants.primaryColor) fontWeight: FontWeight.w600,),),),),],),);}

  Widget _buildDetailItem(IconData icon, String text) {
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
              color: Color(0xFF64748B)), maxLines: 1,
            overflow: TextOverflow.ellipsis,),),],);}

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade400,),const SizedBox(height: 16)Text(
            'Bu kategoride operasyon bulunmuyor',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,),),],),);}

  void _showOperationDetails(Map<String, dynamic> operation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),), child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 8) width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),),Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24) child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status and Priority
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6,), decoration: BoxDecoration(
                              color: operation['status'] == 'active'
                                  ? const Color(0xFF10B981).withValues(alpha: 0.1)
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20)), child: Text(
                              operation['status'] == 'active'
                                  ? 'Aktif'
                                  : 'Tamamlandı',
                              style: TextStyle(
                                color: operation['status'] == 'active'
                                    ? const Color(0xFF10B981)
                                    : Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,),),),const Spacer(),
                          Text(
                            'Öncelik: ${operation['priority'] == 'high' ? 'Yüksek' : operation['priority'] == 'medium' ? 'Orta' : 'Düşük'}',
                            style: const TextStyle(
                              color: Color(0xFF64748B) fontSize: 12,),),],),const SizedBox(height: 16)// Title
                      Text(
                        operation['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A)),),const SizedBox(height: 12)// Description
                      Text(
                        operation['description'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF64748B) height: 1.5,),),const SizedBox(height: 20)// Details Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailCard(
                              'Konum',
                              operation['location'],
                              Icons.location_on,),),const SizedBox(width: 12)Expanded(
                            child: _buildDetailCard(
                              'Ekip',
                              '${operation['teamSize']} Kişi',
                              Icons.people,),),],),const SizedBox(height: 12)Row(
                        children: [
                          Expanded(
                            child: _buildDetailCard(
                              'Koordinatör',
                              operation['coordinator'],
                              Icons.person,),),const SizedBox(width: 12)Expanded(
                            child: _buildDetailCard(
                              'Başlangıç',
                              DateFormat('dd.MM.yyyy')
                                  .format(operation['startDate']),
                              Icons.calendar_today,),),],),if (operation['endDate'] != null) ...[
                        const SizedBox(height: 12)_buildDetailCard(
                          'Bitiş',
                          DateFormat('dd.MM.yyyy').format(operation['endDate']),
                          Icons.calendar_today,),],const SizedBox(height: 24)// Updates
                      if (operation['updates'] != null &&
                          operation['updates'].isNotEmpty) ...[
                        const Text(
                          'Operasyon Güncellemeleri',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A)),),const SizedBox(height: 12)...operation['updates'].map<Widget>((update) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8) padding: const EdgeInsets.all(12) decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8)), child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('dd.MM').format(update['date']), style: const TextStyle(
                                    color: Color(0xFF64748B) fontSize: 12,
                                    fontWeight: FontWeight.w600,),),const SizedBox(width: 12)Expanded(
                                  child: Text(
                                    update['message'],
                                    style: const TextStyle(
                                      color: Color(0xFF0F172A) fontSize: 14,),),),],),);}),],],),),),],),),),);}

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12) decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8)), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: const Color(AppConstants.primaryColor)),const SizedBox(width: 4)Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B) fontWeight: FontWeight.w500,),),],),const SizedBox(height: 4)Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0F172A) fontWeight: FontWeight.w600,),),],),);}
}






