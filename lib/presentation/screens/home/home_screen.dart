import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Home Screen - Ana Ekran
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC) drawer: _buildDrawer(), body: SafeArea(
        child: _selectedIndex == 0
            ? _buildHomeContent()
            : Center(child: Text('Sayfa ${_selectedIndex + 1}')),), bottomNavigationBar: _buildBottomNavBar(),);}

  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        // App Bar
        _buildAppBar(),

        SliverToBoxAdapter(
          child: Column(
            children: [
              // Acil Erişim Butonları
              _buildQuickActions(),

              // Duyuru Banner (varsa)
              _buildAnnouncementBanner(),

              // Aktif Operasyonlar
              _buildActiveOperations(),

              // Yaklaşan Etkinlikler
              _buildUpcomingEvents(),

              // Son Haberler
              _buildRecentNews(),

              // İstatistikler
              _buildStatistics(),

              // Hızlı Bağlantılar
              _buildQuickLinks(),

              const SizedBox(height: 80)// Bottom nav için boşluk
            ],),),],);}

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: const Color(0xFF003875) elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white) onPressed: () => Scaffold.of(context).openDrawer(),),), title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)), child: const Icon(
              Icons.emergency,
              color: Color(0xFF003875) size: 20,),),const SizedBox(width: 8)const Text(
            'TULPARS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,),),],), centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Colors.white,), onPressed: () {
                context.go('/notifications');
              },),Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4) decoration: const BoxDecoration(
                  color: Color(0xFFDC2626) shape: BoxShape.circle,), constraints: const BoxConstraints(minWidth: 16, minHeight: 16) child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),),),],),IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white) onPressed: () {
            context.go('/profile');
          },),const SizedBox(width: 8)],);}

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16) child: Row(
        children: [
          Expanded(
            child: _buildQuickActionButton(
              icon: Icons.warning_amber_rounded,
              label: 'ACİL\nDURUM',
              color: const Color(0xFFDC2626) onTap: () {
                context.go('/emergency');
              },),),const SizedBox(width: 12)Expanded(
            child: _buildQuickActionButton(
              icon: Icons.volunteer_activism,
              label: 'BAĞIŞ\nYAP',
              color: const Color(0xFFF59E0B) onTap: () {
                context.go('/donations');
              },
              semanticLabel: 'Bağış yap butonu, bağış ekranına gider',),),const SizedBox(width: 12)Expanded(
            child: _buildQuickActionButton(
              icon: Icons.person_add,
              label: 'ÜYE\nOL',
              color: const Color(0xFF10B981) onTap: () {
                context.go('/membership');
              },
              semanticLabel: 'Üye ol butonu, üyelik ekranına gider',),),],),);}

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    String? semanticLabel,},) {
    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16) child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20) decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16) boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3) blurRadius: 8,
                offset: const Offset(0, 4)),],), child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 32)const SizedBox(height: 8)Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.2,),),],),),),);}

  Widget _buildAnnouncementBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8) padding: const EdgeInsets.all(16) decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003875)Color(0xFF0055A5)],), borderRadius: BorderRadius.circular(12)), child: Row(
        children: [
          const Icon(Icons.campaign, color: Colors.white, size: 32)const SizedBox(width: 12)const Expanded(
            child: Text(
              'Yeni eğitim programımız başladı!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,),),),IconButton(
            icon: const Icon(Icons.arrow_forward, color: Colors.white) onPressed: () {},),],),);}

  Widget _buildActiveOperations() {
    return _buildSection(
      title: '🚁 Aktif Operasyonlar',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16) padding: const EdgeInsets.all(16) decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16) boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05) blurRadius: 10,
              offset: const Offset(0, 2)),],), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981) shape: BoxShape.circle,),),const SizedBox(width: 8)const Text(
                  'Devam Ediyor',
                  style: TextStyle(
                    color: Color(0xFF10B981) fontWeight: FontWeight.w600,
                    fontSize: 12,),),],),const SizedBox(height: 12)const Text(
              'Hatay Bölgesi Arama Kurtarma',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A)),),const SizedBox(height: 8)_buildInfoRow(Icons.location_on, 'Hatay Merkez'),
            _buildInfoRow(Icons.people, '25 Gönüllü'),
            _buildInfoRow(Icons.access_time, '3 Gün'),
            const SizedBox(height: 12)SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF003875) side: const BorderSide(color: Color(0xFF003875)), shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),), child: const Text('Detayları Gör'),),),],),),);}

  Widget _buildUpcomingEvents() {
    return _buildSection(
      title: '📅 Yaklaşan Etkinlikler',
      onSeeAll: () {},
      child: SizedBox(
        height: 160,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16) scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              width: 280,
              margin: const EdgeInsets.only(right: 12) padding: const EdgeInsets.all(16) decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16) boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05) blurRadius: 10,
                    offset: const Offset(0, 2)),],), child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8) decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.1) borderRadius: BorderRadius.circular(8)), child: const Icon(
                          Icons.calendar_today,
                          color: Color(0xFFF59E0B) size: 20,),),const SizedBox(width: 8)const Text(
                        '15 Aralık 2024',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B) fontWeight: FontWeight.w500,),),],),const SizedBox(height: 12)const Text(
                    'İlk Yardım Eğitimi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A)),),const SizedBox(height: 4)const Text(
                    'Maltepe Merkez',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),),const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.people,
                        size: 16,
                        color: Color(0xFF64748B)),const SizedBox(width: 4)const Text(
                        '45 Katılımcı',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B)),),const Spacer(),
                      TextButton(onPressed: () {}, child: const Text('Katıl')),],),],),);},),),);}

  Widget _buildRecentNews() {
    return _buildSection(
      title: '📰 Son Haberler',
      onSeeAll: () {},
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16) shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), itemCount: 3,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12) decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12) boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05) blurRadius: 10,
                  offset: const Offset(0, 2)),],), child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12) child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF003875).withValues(alpha: 0.1) borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12) bottomLeft: Radius.circular(12)),), child: const Icon(
                      Icons.image,
                      color: Color(0xFF003875) size: 40,),),Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12) child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Haber Başlığı ${index + 1}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A)), maxLines: 2,
                            overflow: TextOverflow.ellipsis,),const SizedBox(height: 4)const Text(
                            '2 saat önce',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF64748B)),),],),),),const Padding(
                    padding: EdgeInsets.only(right: 12) child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Color(0xFF64748B)),),],),),);},),);}

  Widget _buildStatistics() {
    return Padding(
      padding: const EdgeInsets.all(16) child: Container(
        padding: const EdgeInsets.all(20) decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF003875)Color(0xFF0055A5)],), borderRadius: BorderRadius.circular(16)), child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('1200+', 'Üye'),
            _buildStatDivider(),
            _buildStatItem('450+', 'Operasyon'),
            _buildStatDivider(),
            _buildStatItem('850+', 'Eğitim'),],),),);}

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,),),const SizedBox(height: 4)Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70)),],);}

  Widget _buildStatDivider() {
    return Container(width: 1, height: 40, color: Colors.white30);
  }

  Widget _buildQuickLinks() {
    final links = [
      {
        'icon': Icons.sports_basketball,
        'label': 'Spor',
        'color': const Color(0xFF003875)},{
        'icon': Icons.sports_basketball,
        'label': 'Spor',
        'color': const Color(0xFF0055A5)'route': '/sports',
      },
      {
        'icon': Icons.school,
        'label': 'Eğitim',
        'color': const Color(0xFF0055A5)'route': '/education',
      },
      {
        'icon': Icons.photo_library,
        'label': 'Galeri',
        'color': const Color(0xFFF59E0B)'route': '/gallery',},{'icon': Icons.info, 'label': 'Hakkımızda', 'color': const Color(0xFF10B981)},];return Padding(
      padding: const EdgeInsets.all(16) child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,), itemCount: links.length,
        itemBuilder: (context, index) {
          final link = links[index];
          return InkWell(
            onTap: () {
              final route = link['route'] as String?;
              if (route != null) {
                context.go(route);
              } else {
                // TODO: Handle other links
                debugPrint('Navigate to ${link['label']}');
              }
            },
            borderRadius: BorderRadius.circular(12) child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12) boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05) blurRadius: 10,
                    offset: const Offset(0, 2)),],), child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    link['icon'] as IconData,
                    color: link['color'] as Color,
                    size: 32,),const SizedBox(height: 8)Text(
                    link['label'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0F172A) fontWeight: FontWeight.w500,),),],),),);},),);}

  Widget _buildSection({
    required String title,
    VoidCallback? onSeeAll,
    required Widget child,},) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12) child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A)),),if (onSeeAll != null)
                TextButton(onPressed: onSeeAll, child: const Text('Tümü')),],),),child,],);}

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4) child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF64748B)),
          const SizedBox(width: 8)Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),),],),);}

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1) blurRadius: 10,
            offset: const Offset(0, -2)),],), child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8) child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Ana Sayfa', 0)_buildNavItem(Icons.article, 'Haberler', 1)_buildNavItem(Icons.add_circle, 'Katıl', 2)_buildNavItem(Icons.event, 'Etkinlik', 3)_buildNavItem(Icons.person, 'Profil', 4)],),),),);}

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return Semantics(
      label: '$label ${isSelected ? 'seçili' : 'seçili değil'}',
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index) child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF003875)
                  : const Color(0xFF64748B) size: 28,),const SizedBox(height: 4)Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected
                    ? const Color(0xFF003875)
                    : const Color(0xFF64748B) fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,),),],),),);}

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF003875)Color(0xFF0055A5)],),), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 35, color: Color(0xFF003875)),),SizedBox(height: 12)Text(
                  'Ahmet Yılmaz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,),),Text(
                  'ahmet@email.com',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),],),),_buildDrawerItem(Icons.home, 'Ana Sayfa', () {}),
          _buildDrawerItem(Icons.info, 'Hakkımızda', () {}),
          _buildDrawerItem(
              Icons.emergency, 'Operasyonlar', () => context.go('/operations'),),
          _buildDrawerItem(Icons.article, 'Haberler', () {}),
          _buildDrawerItem(Icons.sports, 'Spor Kulübü', () {}),
          _buildDrawerItem(Icons.school, 'Eğitimler', () {}),
          _buildDrawerItem(Icons.photo, 'Galeri', () {}),
          _buildDrawerItem(Icons.volunteer_activism, 'Bağış Yap', () {}),
          _buildDrawerItem(Icons.people, 'Destekçiler', () {}),
          _buildDrawerItem(Icons.phone, 'İletişim', () {}),
          _buildDrawerItem(Icons.help, 'SSS', () {}),
          const Divider(),
          _buildDrawerItem(Icons.settings, 'Ayarlar', () {}),
          _buildDrawerItem(Icons.logout, 'Çıkış Yap', () {}),],),);}

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF003875)), title: Text(title) onTap: onTap,);}
}






