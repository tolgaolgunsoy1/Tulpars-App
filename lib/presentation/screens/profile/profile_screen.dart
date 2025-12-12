import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/cache_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _avatarAnimationController;
  late Animation<double> _avatarScaleAnimation;
  late TabController _tabController;

  bool _isEditing = false;
  bool _isLoading = false;
  bool _isDarkMode = false;
  bool _isPrivacyMode = false;
  final int _activitiesPerPage = 10;
  int _currentPage = 0;
  bool _hasMoreActivities = true;
  final ScrollController _scrollController = ScrollController();

  // Services
  final CacheService _cacheService = CacheService();

  // Mock user data
  final Map<String, dynamic> _userData = {
    'name': 'Ahmet',
    'surname': 'Yılmaz',
    'email': 'ahmet@email.com',
    'phone': '+90 555 123 4567',
    'bloodType': 'A+',
    'emergencyContact': '+90 555 987 6543',
    'memberSince': '2020',
    'totalDonations': '2,450₺',
    'operationsParticipated': 12,
    'trainingsCompleted': 8,
    'avatarFrame': 'default',
    'avatarFilter': 'none',
    'bio': 'Yardımsever bir gönüllü', // Yeni
    'location': 'İstanbul, Türkiye', // Yeni
    'badges': ['İlk Bağış', 'Operasyon Kahramanı', 'Eğitim Lideri'], // Yeni
    'socialMedia': {
      'facebook': '',
      'instagram': '',
      'twitter': '',
      'linkedin': '',
    },
    'privacySettings': {
      'profileVisible': true,
      'showDonations': true,
      'showOperations': true,
      'showContact': false,
    },
  };

  // Activity timeline data
  List<Map<String, dynamic>> _allActivities = [];
  List<Map<String, dynamic>> _displayedActivities = [];

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _avatarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _tabController = TabController(length: 3, vsync: this);

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _avatarScaleAnimation = Tween<double>(begin: 1, end: 1.1).animate(
      CurvedAnimation(
          parent: _avatarAnimationController, curve: Curves.elasticOut,),
    );

    _animationController.forward();

    // Initialize activity data
    _initializeActivities();

    // Initialize controllers
    _nameController.text = _userData['name'];
    _surnameController.text = _userData['surname'];
    _emailController.text = _userData['email'];
    _phoneController.text = _userData['phone'];
    _emergencyContactController.text = _userData['emergencyContact'];
    _bioController.text = _userData['bio'] ?? '';
    _locationController.text = _userData['location'] ?? '';

    // Load cached data
    _loadCachedData().then((_) {});

    // Setup infinite scroll
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreActivities();
    }
  }

  void _loadMoreActivities() {
    if (!_hasMoreActivities || _isLoading) return;

    setState(() => _isLoading = true);

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final nextPage = _currentPage + 1;
      final startIndex = nextPage * _activitiesPerPage;
      final endIndex = startIndex + _activitiesPerPage;

      if (startIndex >= _allActivities.length) {
        setState(() {
          _hasMoreActivities = false;
          _isLoading = false;
        });
        return;
      }

      final newActivities =
          _allActivities.skip(startIndex).take(_activitiesPerPage).toList();

      setState(() {
        _displayedActivities.addAll(newActivities);
        _currentPage = nextPage;
        _hasMoreActivities = endIndex < _allActivities.length;
        _isLoading = false;
      });
    });
  }

  void _initializeActivities() {
    _allActivities = [
      {
        'title': 'Operasyon Katılımı',
        'description': 'İstanbul deprem yardımı',
        'date': '2024-12-01',
        'icon': Icons.search,
        'type': 'operation',
        'timestamp': DateTime.parse('2024-12-01'),
      },
      {
        'title': 'Bağış Yapıldı',
        'description': '250₺ bağış',
        'date': '2024-11-28',
        'icon': Icons.volunteer_activism,
        'type': 'donation',
        'timestamp': DateTime.parse('2024-11-28'),
      },
      {
        'title': 'Eğitim Tamamlandı',
        'description': 'İlk yardım eğitimi',
        'date': '2024-11-20',
        'icon': Icons.school,
        'type': 'education',
        'timestamp': DateTime.parse('2024-11-20'),
      },
      {
        'title': 'Galeri Fotoğrafı',
        'description': 'Etkinlik fotoğrafı paylaşıldı',
        'date': '2024-11-15',
        'icon': Icons.photo,
        'type': 'gallery',
        'timestamp': DateTime.parse('2024-11-15'),
      },
      {
        'title': 'Spor Etkinliği',
        'description': 'Futbol turnuvası katılımı',
        'date': '2024-11-10',
        'icon': Icons.sports_soccer,
        'type': 'sports',
        'timestamp': DateTime.parse('2024-11-10'),
      },
      {
        'title': 'Kan Bağışı',
        'description': 'A+ kan grubu bağışı',
        'date': '2024-11-05',
        'icon': Icons.bloodtype,
        'type': 'donation',
        'timestamp': DateTime.parse('2024-11-05'),
      },
      {
        'title': 'Eğitim Semineri',
        'description': 'Acil durum yönetimi eğitimi',
        'date': '2024-10-30',
        'icon': Icons.school,
        'type': 'education',
        'timestamp': DateTime.parse('2024-10-30'),
      },
      {
        'title': 'Operasyon Yardımı',
        'description': 'Sel felaketi yardımı',
        'date': '2024-10-25',
        'icon': Icons.search,
        'type': 'operation',
        'timestamp': DateTime.parse('2024-10-25'),
      },
      {
        'title': 'Galeri Albümü',
        'description': 'Yardım malzemeleri dağıtımı',
        'date': '2024-10-20',
        'icon': Icons.photo_library,
        'type': 'gallery',
        'timestamp': DateTime.parse('2024-10-20'),
      },
      {
        'title': 'Spor Turnuvası',
        'description': 'Yardımlaşma koşusu',
        'date': '2024-10-15',
        'icon': Icons.directions_run,
        'type': 'sports',
        'timestamp': DateTime.parse('2024-10-15'),
      },
      {
        'title': 'Bağış Kampanyası',
        'description': '100₺ bağış',
        'date': '2024-10-10',
        'icon': Icons.volunteer_activism,
        'type': 'donation',
        'timestamp': DateTime.parse('2024-10-10'),
      },
      {
        'title': 'Eğitim Programı',
        'description': 'Yangın güvenliği eğitimi',
        'date': '2024-10-05',
        'icon': Icons.local_fire_department,
        'type': 'education',
        'timestamp': DateTime.parse('2024-10-05'),
      },
    ];

    _allActivities.sort(
      (a, b) =>
          (b['timestamp'] as DateTime).compareTo(a['timestamp'] as DateTime),
    );

    _displayedActivities = _allActivities.take(_activitiesPerPage).toList();
  }

  Future<void> _loadCachedData() async {
    try {
      final cachedProfile =
          _cacheService.get<Map<String, dynamic>>('user_profile');
      if (cachedProfile != null) {
        setState(() {
          _userData.addAll(cachedProfile);
        });
      }

      final cachedActivities =
          _cacheService.get<List<dynamic>>('user_activities');
      if (cachedActivities != null) {
        setState(() {
          _allActivities = cachedActivities
              .map((activity) => activity as Map<String, dynamic>)
              .toList();
          _displayedActivities =
              _allActivities.take(_activitiesPerPage).toList();
        });
      }
    } catch (e) {
      debugPrint('Cache loading error: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _avatarAnimationController.dispose();
    _tabController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _showSuccessSnackBar(_isDarkMode ? 'Koyu mod açıldı' : 'Açık mod açıldı');
  }

  void _togglePrivacyMode() {
    setState(() {
      _isPrivacyMode = !_isPrivacyMode;
    });
    _showSuccessSnackBar(
        _isPrivacyMode ? 'Gizlilik modu açıldı' : 'Gizlilik modu kapatıldı',);
  }

  void _shareProfile() {
    // Share profile functionality disabled
  }

  void _saveProfile() async {
    // Validate inputs
    if (_nameController.text.trim().isEmpty ||
        _surnameController.text.trim().isEmpty) {
      _showErrorSnackBar('Ad ve soyad boş olamaz');
      return;
    }

    if (!_isValidEmail(_emailController.text.trim())) {
      _showErrorSnackBar('Geçerli bir e-posta adresi girin');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 1));

      _userData['name'] = _nameController.text.trim();
      _userData['surname'] = _surnameController.text.trim();
      _userData['email'] = _emailController.text.trim();
      _userData['phone'] = _phoneController.text.trim();
      _userData['emergencyContact'] = _emergencyContactController.text.trim();
      _userData['bio'] = _bioController.text.trim();
      _userData['location'] = _locationController.text.trim();

      // Cache updated data
      await _cacheService.set('user_profile', _userData);

      setState(() => _isLoading = false);
      _toggleEdit();
      _showSuccessSnackBar('Profil bilgileriniz güncellendi');
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Bir hata oluştu. Lütfen tekrar deneyin.');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(AppConstants.successColor),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFDC2626),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final image = await showModalBottomSheet<XFile?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(AppConstants.primaryColor)
                          .withValues(alpha: 26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.photo_camera,
                        color: Color(AppConstants.primaryColor),),
                  ),
                  title: const Text('Kamera'),
                  subtitle: const Text('Yeni fotoğraf çek'),
                  onTap: () async {
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.camera);
                    if (context.mounted) {
                      Navigator.of(context).pop(pickedImage);
                    }
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(AppConstants.primaryColor)
                          .withValues(alpha: 26 / 255),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.photo_library,
                        color: Color(AppConstants.primaryColor),),
                  ),
                  title: const Text('Galeri'),
                  subtitle: const Text('Galeriden seç'),
                  onTap: () async {
                    final pickedImage =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (context.mounted) {
                      Navigator.of(context).pop(pickedImage);
                    }
                  },
                ),
                if (_profileImage != null)
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626).withValues(alpha: 26 / 255),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete, color: Color(0xFFDC2626)),
                    ),
                    title: const Text('Fotoğrafı Kaldır'),
                    onTap: () {
                      setState(() {
                        _profileImage = null;
                      });
                      Navigator.of(context).pop();
                      _showSuccessSnackBar('Profil fotoğrafı kaldırıldı');
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
      _avatarAnimationController.forward(from: 0);
      _showSuccessSnackBar('Profil fotoğrafı güncellendi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/main'),
                tooltip: 'Geri',
              ),
              actions: [
                IconButton(
                  icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
                  onPressed: _toggleDarkMode,
                  tooltip: _isDarkMode ? 'Açık Mod' : 'Koyu Mod',
                ),
                IconButton(
                  icon: Icon(
                      _isPrivacyMode ? Icons.visibility_off : Icons.visibility,),
                  onPressed: _togglePrivacyMode,
                  tooltip: _isPrivacyMode
                      ? 'Gizlilik Modu Açık'
                      : 'Gizlilik Modu Kapalı',
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: _shareProfile,
                  tooltip: 'Profili Paylaş',
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _toggleEdit();
                        break;
                      case 'settings':
                        context.go('/settings');
                        break;
                      case 'logout':
                        _showLogoutDialog();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(_isEditing ? Icons.close : Icons.edit, size: 20),
                          const SizedBox(width: 12),
                          Text(_isEditing
                              ? 'Düzenlemeyi İptal Et'
                              : 'Profili Düzenle',),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings, size: 20),
                          SizedBox(width: 12),
                          Text('Ayarlar'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout,
                              size: 20, color: Color(0xFFDC2626),),
                          SizedBox(width: 12),
                          Text('Çıkış Yap',
                              style: TextStyle(color: Color(0xFFDC2626)),),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildProfileHeader(),
              ),
            ),
          ];
        },
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Container(
                color: Theme.of(context).colorScheme.surface,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                  tabs: const [
                    Tab(text: 'Genel Bakış'),
                    Tab(text: 'Aktiviteler'),
                    Tab(text: 'Ayarlar'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildActivitiesTab(),
                    _buildSettingsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 179 / 255),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: 'profile_avatar',
                    child: ScaleTransition(
                      scale: _avatarScaleAnimation,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 51 / 255),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          image: _profileImage != null
                              ? DecorationImage(
                                  image: FileImage(_profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Color(AppConstants.primaryColor),
                              )
                            : null,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickProfileImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 51),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${_userData['name']} ${_userData['surname']}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (_userData['bio'] != null && _userData['bio'].isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  _userData['bio'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 230 / 255),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isEditing) _buildProfileInfo() else _buildProfileInfoView(),
          const SizedBox(height: 24),
          _buildStatistics(),
          const SizedBox(height: 24),
          _buildAchievements(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildActivitiesTab() {
    return Column(
      children: [
        Expanded(
          child: _displayedActivities.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Henüz aktivite yok',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _displayedActivities.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _displayedActivities.length) {
                      return _hasMoreActivities
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const SizedBox(height: 80);
                    }

                    final activity = _displayedActivities[index];
                    return _buildActivityCard(activity);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getActivityColor(activity['type'] as String)
                .withValues(alpha: 26 / 255),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            activity['icon'] as IconData,
            color: _getActivityColor(activity['type'] as String),
            size: 24,
          ),
        ),
        title: Text(
          activity['title'] as String,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              activity['description'] as String,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  activity['date'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        onTap: () {
          // TODO: Navigate to activity detail
        },
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gizlilik Ayarları',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildPrivacySettings(),
          const SizedBox(height: 24),
          Text(
            'Sosyal Medya',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          _buildSocialMedia(),
          const SizedBox(height: 24),
          _buildMenuItems(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildProfileInfoView() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Kişisel Bilgiler',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _toggleEdit,
                  tooltip: 'Düzenle',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.person_outline, 'Ad Soyad',
                '${_userData['name']} ${_userData['surname']}',),
            const Divider(height: 24),
            _buildInfoRow(Icons.email_outlined, 'E-posta', _userData['email']),
            const Divider(height: 24),
            _buildInfoRow(Icons.phone_outlined, 'Telefon', _userData['phone']),
            const Divider(height: 24),
            _buildInfoRow(
                Icons.bloodtype_outlined, 'Kan Grubu', _userData['bloodType'],),
            const Divider(height: 24),
            _buildInfoRow(Icons.contact_emergency_outlined, 'Acil Kişi',
                _userData['emergencyContact'],),
            if (_userData['location'] != null &&
                _userData['location'].isNotEmpty) ...[
              const Divider(height: 24),
              _buildInfoRow(
                  Icons.location_on_outlined, 'Konum', _userData['location'],),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(AppConstants.primaryColor).withValues(alpha: 26 / 255),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon,
              size: 20, color: const Color(AppConstants.primaryColor),),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kişisel Bilgiler',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: 'Ad',
              controller: _nameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: 'Soyad',
              controller: _surnameController,
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: 'E-posta',
              controller: _emailController,
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: 'Telefon',
              controller: _phoneController,
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: 'Kan Grubu',
              initialValue: _userData['bloodType'],
              icon: Icons.bloodtype_outlined,
              enabled: false,
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: 'Acil Durum Kişisi',
              controller: _emergencyContactController,
              icon: Icons.contact_emergency_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: 'Biyografi',
              controller: _bioController,
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildInfoField(
              label: 'Konum',
              controller: _locationController,
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _toggleEdit,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(AppConstants.primaryColor),),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('İptal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(AppConstants.primaryColor),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Kaydet'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    TextEditingController? controller,
    String? initialValue,
    required IconData icon,
    TextInputType? keyboardType,
    bool enabled = true,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      enabled: _isEditing && enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(AppConstants.primaryColor)),
        ),
        filled: !_isEditing || !enabled,
        fillColor: _isEditing && enabled ? null : Colors.grey.shade50,
      ),
    );
  }

  Widget _buildStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'İstatistikler',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: [
            _buildStatCard(
              title: 'Toplam Bağış',
              value: _userData['totalDonations'],
              icon: Icons.volunteer_activism,
              color: const Color(0xFFDC2626),
            ),
            _buildStatCard(
              title: 'Operasyon',
              value: '${_userData['operationsParticipated']}',
              icon: Icons.search,
              color: const Color(0xFFF59E0B),
            ),
            _buildStatCard(
              title: 'Eğitim',
              value: '${_userData['trainingsCompleted']}',
              icon: Icons.school,
              color: const Color(0xFF10B981),
            ),
            _buildStatCard(
              title: 'Üyelik Yılı',
              value: _userData['memberSince'],
              icon: Icons.calendar_today,
              color: const Color(AppConstants.primaryColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 26 / 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {
        'title': 'İlk Bağış',
        'description': 'İlk bağışınızı yaptınız',
        'icon': Icons.star,
        'earned': true,
      },
      {
        'title': 'Operasyon Kahramanı',
        'description': '5 operasyona katıldınız',
        'icon': Icons.local_fire_department,
        'earned': true,
      },
      {
        'title': 'Eğitim Lideri',
        'description': '10 eğitim tamamladınız',
        'icon': Icons.school,
        'earned': true,
      },
      {
        'title': 'Sadık Üye',
        'description': '5 yıldır üyemiz',
        'icon': Icons.verified,
        'earned': false,
      },
      {
        'title': 'Bağış Şampiyonu',
        'description': '1000₺ üzeri bağış',
        'icon': Icons.emoji_events,
        'earned': false,
      },
      {
        'title': 'Yıldız Gönüllü',
        'description': '20 operasyon katılımı',
        'icon': Icons.military_tech,
        'earned': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Başarılar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Navigate to all achievements
              },
              icon: const Icon(Icons.emoji_events, size: 18),
              label: const Text('Tümü'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return _buildAchievementCard(
              title: achievement['title'] as String,
              description: achievement['description'] as String,
              icon: achievement['icon'] as IconData,
              earned: achievement['earned'] as bool,
            );
          },
        ),
      ],
    );
  }

  Widget _buildAchievementCard({
    required String title,
    required String description,
    required IconData icon,
    required bool earned,
  }) {
    return InkWell(
      onTap: () {
        // Show achievement details
        _showAchievementDialog(title, description, icon, earned);
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: earned ? 3 : 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: earned
                      ? const Color(0xFFF59E0B).withValues(alpha: 26 / 255)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: earned ? const Color(0xFFF59E0B) : Colors.grey,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: earned ? const Color(0xFF0F172A) : Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievementDialog(
      String title, String description, IconData icon, bool earned,) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: earned
                    ? const Color(0xFFF59E0B).withValues(alpha: 26 / 255)
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: earned ? const Color(0xFFF59E0B) : Colors.grey,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: earned
                    ? const Color(0xFF10B981).withValues(alpha: 26 / 255)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    earned ? Icons.check_circle : Icons.lock,
                    size: 16,
                    color: earned ? const Color(0xFF10B981) : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    earned ? 'Kazanıldı' : 'Kilitli',
                    style: TextStyle(
                      color: earned ? const Color(0xFF10B981) : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Profil Görünürlüğü'),
            subtitle: const Text('Profilinizi diğer kullanıcılar görebilir'),
            value: _userData['privacySettings']['profileVisible'],
            onChanged: (value) {
              setState(() {
                _userData['privacySettings']['profileVisible'] = value;
              });
            },
            secondary: const Icon(Icons.visibility),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Bağışları Göster'),
            subtitle: const Text('Bağış geçmişinizi paylaş'),
            value: _userData['privacySettings']['showDonations'],
            onChanged: (value) {
              setState(() {
                _userData['privacySettings']['showDonations'] = value;
              });
            },
            secondary: const Icon(Icons.volunteer_activism),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Operasyonları Göster'),
            subtitle: const Text('Katıldığınız operasyonları paylaş'),
            value: _userData['privacySettings']['showOperations'],
            onChanged: (value) {
              setState(() {
                _userData['privacySettings']['showOperations'] = value;
              });
            },
            secondary: const Icon(Icons.search),
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('İletişim Bilgilerini Göster'),
            subtitle: const Text('Telefon ve e-posta bilgilerinizi paylaş'),
            value: _userData['privacySettings']['showContact'],
            onChanged: (value) {
              setState(() {
                _userData['privacySettings']['showContact'] = value;
              });
            },
            secondary: const Icon(Icons.contact_phone),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMedia() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSocialMediaField(
              icon: Icons.facebook,
              label: 'Facebook',
              platform: 'facebook',
              color: const Color(0xFF1877F2),
            ),
            const SizedBox(height: 12),
            _buildSocialMediaField(
              icon: Icons.camera_alt,
              label: 'Instagram',
              platform: 'instagram',
              color: const Color(0xFFE4405F),
            ),
            const SizedBox(height: 12),
            _buildSocialMediaField(
              icon: Icons.alternate_email,
              label: 'Twitter',
              platform: 'twitter',
              color: const Color(0xFF1DA1F2),
            ),
            const SizedBox(height: 12),
            _buildSocialMediaField(
              icon: Icons.work,
              label: 'LinkedIn',
              platform: 'linkedin',
              color: const Color(0xFF0A66C2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMediaField({
    required IconData icon,
    required String label,
    required String platform,
    required Color color,
  }) {
    return TextFormField(
      initialValue: _userData['socialMedia'][platform],
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: color),
        ),
      ),
      onChanged: (value) {
        setState(() {
          _userData['socialMedia'][platform] = value;
        });
      },
    );
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'operation':
        return const Color(0xFFF59E0B);
      case 'donation':
        return const Color(0xFFDC2626);
      case 'education':
        return const Color(0xFF10B981);
      case 'gallery':
        return const Color(0xFF8B5CF6);
      case 'sports':
        return const Color(0xFF3B82F6);
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Widget _buildMenuItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Diğer Ayarlar',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: 'Bildirimler',
                subtitle: 'Bildirim tercihlerinizi yönetin',
                onTap: () {
                  // TODO: Navigate to notifications settings
                },
              ),
              const Divider(height: 1),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'Yardım & Destek',
                subtitle: 'Sıkça sorulan sorular',
                onTap: () {
                  // TODO: Navigate to help screen
                },
              ),
              const Divider(height: 1),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'Hakkında',
                subtitle: 'Uygulama bilgileri',
                onTap: () {
                  // TODO: Navigate to about screen
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 26 / 255),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout, color: Color(0xFFDC2626)),
            ),
            title: const Text(
              'Çıkış Yap',
              style: TextStyle(
                color: Color(0xFFDC2626),
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text('Hesabınızdan çıkış yapın'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showLogoutDialog,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(AppConstants.primaryColor).withValues(alpha: 26 / 255),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(AppConstants.primaryColor)),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 26 / 255),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout, color: Color(0xFFDC2626)),
            ),
            const SizedBox(width: 12),
            const Text('Çıkış Yap'),
          ],
        ),
        content: const Text(
          'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/auth');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            child: const Text('Çıkış'),
          ),
        ],
      ),
    );
  }
}
