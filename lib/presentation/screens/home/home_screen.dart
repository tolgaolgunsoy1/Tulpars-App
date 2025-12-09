import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Home Screen - Ana Ekran
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.child});

  final Widget child;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Constants
  static const _primaryColor = Color(0xFF003875);
  static const _secondaryColor = Color(0xFF0055A5);
  static const _backgroundColor = Color(0xFFF8FAFC);
  static const _textPrimaryColor = Color(0xFF0F172A);
  static const _errorColor = Color(0xFFDC2626);
  static const _warningColor = Color(0xFFF59E0B);
  static const _successColor = Color(0xFF10B981);

  int _getSelectedIndex(String location) {
    const routeIndexMap = {
      '/main': 0,
      '/news': 1,
      '/membership': 2,
      '/sports': 3,
      '/profile': 4,
    };
    return routeIndexMap[location] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();
    final selectedIndex = _getSelectedIndex(currentLocation);
    final isMainScreen = currentLocation == '/main';

    return Scaffold(
      backgroundColor: _backgroundColor,
      drawer: isMainScreen ? _buildDrawer(context) : null,
      body: SafeArea(
        child: isMainScreen ? _buildHomeContent() : widget.child,
      ),
      bottomNavigationBar: _buildBottomNavBar(selectedIndex),
    );
  }

  Widget _buildHomeContent() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: _primaryColor,
      child: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildQuickActions(),
                _buildAnnouncementBanner(),
                _buildActiveOperations(),
                _buildUpcomingEvents(),
                _buildRecentNews(),
                _buildStatistics(),
                _buildQuickLinks(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // TODO: Implement data refresh logic
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İçerik güncellendi')),
      );
    }
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: _primaryColor,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: 'Menü',
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: 'app_logo',
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/appstore.png',
                  width: 20,
                  height: 20,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.shield,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'TULPARS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        _buildNotificationButton(),
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white),
          onPressed: () => context.go('/profile'),
          tooltip: 'Profil',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildNotificationButton() {
    const notificationCount = 3;

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () => context.go('/notifications'),
          tooltip: 'Bildirimler',
        ),
        if (notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: _errorColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: const Text(
                notificationCount > 9 ? '9+' : '$notificationCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionButton(
              icon: Icons.warning_amber_rounded,
              label: 'ACİL\nDURUM',
              color: _errorColor,
              onTap: () => context.go('/emergency'),
              semanticLabel: 'Acil durum butonu, acil durum ekranına gider',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickActionButton(
              icon: Icons.volunteer_activism,
              label: 'BAĞIŞ\nYAP',
              color: _warningColor,
              onTap: () => context.go('/donations'),
              semanticLabel: 'Bağış yap butonu, bağış ekranına gider',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickActionButton(
              icon: Icons.person_add,
              label: 'ÜYE\nOL',
              color: _successColor,
              onTap: () => context.go('/membership'),
              semanticLabel: 'Üye ol butonu, üyelik ekranına gider',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showAnnouncementDialog,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.campaign, color: Colors.white, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yeni eğitim programımız başladı!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Detaylar için tıklayın',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAnnouncementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.campaign, color: _primaryColor),
            SizedBox(width: 8),
            Text('Duyuru Detayı'),
          ],
        ),
        content: const Text(
          'Yeni eğitim programımız 15 Aralık\'ta başlıyor. '
          'İlk yardım, arama kurtarma ve daha birçok konuda eğitimler verilecektir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/education');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eğitimlere Git'),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOperations() {
    return _SectionWrapper(
      title: '🚁 Aktif Operasyonlar',
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusBadge('Devam Ediyor', _successColor),
            const SizedBox(height: 12),
            const Text(
              'Hatay Bölgesi Arama Kurtarma',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const _InfoRow(icon: Icons.location_on, text: 'Hatay Merkez'),
            const _InfoRow(icon: Icons.people, text: '25 Gönüllü'),
            const _InfoRow(icon: Icons.access_time, text: '3 Gün'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.go('/operations'),
                icon: const Icon(Icons.visibility),
                label: const Text('Detayları Gör'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _primaryColor,
                  side: const BorderSide(color: _primaryColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingEvents() {
    return _SectionWrapper(
      title: '📅 Yaklaşan Etkinlikler',
      onSeeAll: () => context.go('/events'),
      child: SizedBox(
        height: 180,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (context, index) => _EventCard(index: index),
        ),
      ),
    );
  }

  Widget _buildRecentNews() {
    return _SectionWrapper(
      title: '📰 Son Haberler',
      onSeeAll: () => context.go('/news'),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index) => _NewsCard(index: index),
      ),
    );
  }

  Widget _buildStatistics() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_primaryColor, _secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _primaryColor.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(value: '1200+', label: 'Üye'),
            _StatDivider(),
            _StatItem(value: '450+', label: 'Operasyon'),
            _StatDivider(),
            _StatItem(value: '850+', label: 'Eğitim'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLinks() {
    final links = [
      const _QuickLink(
        icon: Icons.sports_basketball,
        label: 'Spor',
        color: _primaryColor,
        route: '/sports',
      ),
      const _QuickLink(
        icon: Icons.school,
        label: 'Eğitim',
        color: _secondaryColor,
        route: '/education',
      ),
      const _QuickLink(
        icon: Icons.photo_library,
        label: 'Galeri',
        color: _warningColor,
        route: '/gallery',
      ),
      const _QuickLink(
        icon: Icons.info,
        label: 'Hakkımızda',
        color: _successColor,
        route: '/about',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: links.length,
        itemBuilder: (context, index) {
          final link = links[index];
          return _QuickLinkCard(link: link);
        },
      ),
    );
  }

  Widget _buildBottomNavBar(int selectedIndex) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Ana Sayfa',
                index: 0,
                route: '/main',
                isSelected: selectedIndex == 0,
              ),
              _NavItem(
                icon: Icons.article_outlined,
                selectedIcon: Icons.article,
                label: 'Haberler',
                index: 1,
                route: '/news',
                isSelected: selectedIndex == 1,
              ),
              _NavItem(
                icon: Icons.add_circle_outline,
                selectedIcon: Icons.add_circle,
                label: 'Katıl',
                index: 2,
                route: '/membership',
                isSelected: selectedIndex == 2,
              ),
              _NavItem(
                icon: Icons.event_outlined,
                selectedIcon: Icons.event,
                label: 'Etkinlik',
                index: 3,
                route: '/sports',
                isSelected: selectedIndex == 3,
              ),
              _NavItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profil',
                index: 4,
                route: '/profile',
                isSelected: selectedIndex == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerItem(
                  icon: Icons.home,
                  title: 'Ana Sayfa',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/main');
                  },
                ),
                _DrawerItem(
                  icon: Icons.info,
                  title: 'Hakkımızda',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/about');
                  },
                ),
                _DrawerItem(
                  icon: Icons.emergency,
                  title: 'Operasyonlar',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/operations');
                  },
                ),
                _DrawerItem(
                  icon: Icons.article,
                  title: 'Haberler',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/news');
                  },
                ),
                _DrawerItem(
                  icon: Icons.sports,
                  title: 'Spor Kulübü',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/sports');
                  },
                ),
                _DrawerItem(
                  icon: Icons.school,
                  title: 'Eğitimler',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/education');
                  },
                ),
                _DrawerItem(
                  icon: Icons.photo,
                  title: 'Galeri',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/gallery');
                  },
                ),
                _DrawerItem(
                  icon: Icons.volunteer_activism,
                  title: 'Bağış Yap',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/donations');
                  },
                ),
                _DrawerItem(
                  icon: Icons.people,
                  title: 'Destekçiler',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/supporters');
                  },
                ),
                _DrawerItem(
                  icon: Icons.phone,
                  title: 'İletişim',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/contact');
                  },
                ),
                _DrawerItem(
                  icon: Icons.help,
                  title: 'SSS',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/faq');
                  },
                ),
                const Divider(),
                _DrawerItem(
                  icon: Icons.settings,
                  title: 'Ayarlar',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/settings');
                  },
                ),
                _DrawerItem(
                  icon: Icons.logout,
                  title: 'Çıkış Yap',
                  textColor: _errorColor,
                  onTap: () => _handleLogout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: _primaryColor),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ahmet Yılmaz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'ahmet@email.com',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/profile');
                },
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Profili Düzenle'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Çıkış yapmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Close drawer
              // TODO: Implement logout logic
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }
}

// Reusable Components
class _QuickActionButton extends StatelessWidget {

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.semanticLabel,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionWrapper extends StatelessWidget {

  const _SectionWrapper({
    required this.title,
    this.onSeeAll,
    required this.child,
  });
  final String title;
  final VoidCallback? onSeeAll;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              if (onSeeAll != null)
                TextButton.icon(
                  onPressed: onSeeAll,
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Tümü'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF003875),
                  ),
                ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {

  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF64748B)),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {

  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: Colors.white30);
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        child: InkWell(
          onTap: () {
            // TODO: Navigate to event details
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFFF59E0B),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'İlk Yardım Eğitimi ${index + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Maltepe Merkez',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.people,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '45 Katılımcı',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF003875),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('Katıl'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go('/news'),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF003875).withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: const Icon(
                  Icons.image,
                  color: Color(0xFF003875),
                  size: 40,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Haber Başlığı ${index + 1}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '2 saat önce',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickLink {

  const _QuickLink({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  });
  final IconData icon;
  final String label;
  final Color color;
  final String route;
}

class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({required this.link});

  final _QuickLink link;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      child: InkWell(
        onTap: () => context.go(link.route),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(link.icon, color: link.color, size: 32),
            const SizedBox(height: 8),
            Text(
              link.label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    required this.route,
    required this.isSelected,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final String route;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label ${isSelected ? 'seçili' : 'seçili değil'}',
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: () => context.go(route),
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected
                    ? const Color(0xFF003875)
                    : const Color(0xFF64748B),
                size: 26,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? const Color(0xFF003875)
                      : const Color(0xFF64748B),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? const Color(0xFF003875),
      ),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
