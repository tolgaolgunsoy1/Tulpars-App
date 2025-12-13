import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/user_role.dart';
import '../../../core/services/user_service.dart';
import '../../../core/models/event_model.dart';
import '../../../core/services/event_service.dart';
import '../../../core/models/news_model.dart';
import '../../../core/services/news_service.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final UserService _userService = UserService();
  List<UserModel> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      _users = await _userService.getAllUsers();
    } catch (e) {
      _showError('Kullanıcılar yüklenemedi: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yönetici Paneli'),
        backgroundColor: const Color(0xFF003875),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDemoAdminCard(),
                const SizedBox(height: 24),
                _buildEventManagementCard(),
                const SizedBox(height: 16),
                _buildNewsManagementCard(),
                const SizedBox(height: 16),
                _buildUserManagementCard(),
                const SizedBox(height: 16),
                _buildStatsCards(),
              ],
            ),
    );
  }

  Widget _buildDemoAdminCard() {
    const credentials = {
      'username': 'admin',
      'email': 'admin@tulpars.org',
      'password': 'Tulpars2024!',
    };
    return Card(
      color: const Color(0xFF003875),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.admin_panel_settings, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Admin Hesabı',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCredentialRow('Kullanıcı Adı', credentials['username']!),
            _buildCredentialRow('E-posta', credentials['email']!),
            _buildCredentialRow('Şifre', credentials['password']!),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.verified, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Kalıcı admin hesabı - Süresiz',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final guestCount = _users.where((u) => u.role == UserRole.guest).length;
    final memberCount = _users.where((u) => u.role == UserRole.member).length;
    final presidentCount = _users.where((u) => u.role == UserRole.president).length;
    final adminCount = _users.where((u) => u.role == UserRole.admin).length;

    return Row(
      children: [
        Expanded(child: _buildStatCard('Misafir', guestCount, Colors.grey)),
        const SizedBox(width: 8),
        Expanded(child: _buildStatCard('Üye', memberCount, Colors.blue)),
        const SizedBox(width: 8),
        Expanded(child: _buildStatCard('Başkan', presidentCount, Colors.orange)),
        const SizedBox(width: 8),
        Expanded(child: _buildStatCard('Yönetici', adminCount, Colors.red)),
      ],
    );
  }

  Widget _buildStatCard(String label, int count, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserManagementCard() {
    final totalUsers = _users.length;
    final activeUsers = _users.where((u) => u.isActive).length;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.people, color: Color(0xFF003875)),
                SizedBox(width: 8),
                Text(
                  'Kullanıcı Yönetimi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Toplam $totalUsers kullanıcı, $activeUsers aktif',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showUsersDialog(),
                icon: const Icon(Icons.visibility),
                label: const Text('Kullanıcıları Görüntüle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003875),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsManagementCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.article, color: Color(0xFF003875)),
                SizedBox(width: 8),
                Text(
                  'Haber Yönetimi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Yeni haber ekle, mevcut haberleri düzenle',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddNewsDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Yeni Haber'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003875),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showNewsListDialog(),
                    icon: const Icon(Icons.list),
                    label: const Text('Haberleri Gör'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF003875),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNewsDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _AddNewsScreen(),
      ),
    );
  }

  void _showEventsListDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Etkinlik Listesi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFF003875),
            foregroundColor: Colors.white,
          ),
          body: FutureBuilder<List<EventModel>>(
            future: EventService.getEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final eventsList = snapshot.data ?? [];
              
              if (eventsList.isEmpty) {
                return const Center(
                  child: Text('Henüz etkinlik yok'),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: eventsList.length,
                itemBuilder: (context, index) {
                  final event = eventsList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        event.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(event.description),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF003875).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  event.category,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF003875),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                event.timeUntilEvent,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${event.currentParticipants}/${event.maxParticipants} katılımcı',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Düzenle'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Sil'),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) async {
                          if (value == 'edit') {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => _EditEventScreen(event: event),
                              ),
                            );
                          } else if (value == 'delete') {
                            final success = await EventService.deleteEvent(event.id);
                            if (success) {
                              Navigator.pop(context);
                              _showEventsListDialog(); // Refresh
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Etkinlik silindi'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showNewsListDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Haber Listesi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFF003875),
            foregroundColor: Colors.white,
          ),
          body: FutureBuilder<List<NewsModel>>(
            future: NewsService.getNews(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final newsList = snapshot.data ?? [];
              
              if (newsList.isEmpty) {
                return const Center(
                  child: Text('Henüz haber yok'),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        news.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(news.shortContent),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF003875).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  news.category,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF003875),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                news.timeAgo,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue),
                                SizedBox(width: 8),
                                Text('Düzenle'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Sil'),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) async {
                          if (value == 'edit') {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => _EditNewsScreen(news: news),
                              ),
                            );
                          } else if (value == 'delete') {
                            final success = await NewsService.deleteNews(news.id);
                            if (success) {
                              Navigator.pop(context);
                              _showNewsListDialog(); // Refresh
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Haber silindi'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showUsersDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Kullanıcı Listesi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFF003875),
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return _buildUserCard(user);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(user.role),
          child: Text(
            user.displayName?.substring(0, 1).toUpperCase() ?? 'U',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(user.displayName ?? user.email),
        subtitle: Text(user.role.displayName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user.isDemo)
              const Icon(Icons.science, color: Colors.orange, size: 20),
            if (user.isExpired)
              const Icon(Icons.timer_off, color: Colors.red, size: 20),
            if (!user.isActive)
              const Icon(Icons.block, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEventManagementCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.event, color: Color(0xFF003875)),
                SizedBox(width: 8),
                Text(
                  'Etkinlik Yönetimi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Yeni etkinlik ekle, mevcut etkinlikleri düzenle',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddEventDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Yeni Etkinlik'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003875),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showEventsListDialog(),
                    icon: const Icon(Icons.list),
                    label: const Text('Etkinlikleri Gör'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF003875),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEventDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _AddEventScreen(),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.guest:
        return Colors.grey;
      case UserRole.member:
        return Colors.blue;
      case UserRole.president:
        return Colors.orange;
      case UserRole.admin:
        return Colors.red;
    }
  }
}

class _AddEventScreen extends StatefulWidget {
  @override
  State<_AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<_AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final maxParticipantsController = TextEditingController();
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedCategory = 'Eğitim';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yeni Etkinlik Ekle',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF003875),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Etkinlik Adı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Etkinlik adı gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Açıklama gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Konum',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Konum gerekli' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: ['Eğitim', 'Tatbikat', 'Sosyal', 'Spor']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => selectedCategory = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: maxParticipantsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Maksimum Katılımcı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty == true) return 'Katılımcı sayısı gerekli';
                  if (int.tryParse(value!) == null) return 'Geçerli bir sayı girin';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  title: const Text('Etkinlik Tarihi'),
                  subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003875),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Etkinlik Ekle', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final event = EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
      location: locationController.text,
      category: selectedCategory,
      maxParticipants: int.parse(maxParticipantsController.text),
      createdAt: DateTime.now(),
    );

    final success = await EventService.addEvent(event);
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Etkinlik başarıyla eklendi!' : 'Hata oluştu'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

class _AddNewsScreen extends StatefulWidget {
  @override
  State<_AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<_AddNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final authorController = TextEditingController(text: 'Tulpars Derneği');
  String selectedCategory = 'Genel';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Yeni Haber Ekle',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF003875),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Haber Başlığı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Haber başlığı gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contentController,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Haber İçeriği',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) => value?.isEmpty == true ? 'Haber içeriği gerekli' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: ['Genel', 'Arama-Kurtarma', 'Eğitim', 'Tatbikat', 'Sosyal']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => selectedCategory = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'Yazar',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Yazar gerekli' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003875),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Haber Yayınla', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveNews() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final news = NewsModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      content: contentController.text,
      category: selectedCategory,
      author: authorController.text,
      publishDate: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final success = await NewsService.addNews(news);
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Haber başarıyla yayınlandı!' : 'Hata oluştu'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

class _EditEventScreen extends StatefulWidget {
  final EventModel event;
  
  const _EditEventScreen({required this.event});

  @override
  State<_EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<_EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController locationController;
  late final TextEditingController maxParticipantsController;
  late DateTime selectedDate;
  late String selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.event.title);
    descriptionController = TextEditingController(text: widget.event.description);
    locationController = TextEditingController(text: widget.event.location);
    maxParticipantsController = TextEditingController(text: widget.event.maxParticipants.toString());
    selectedDate = widget.event.date;
    selectedCategory = widget.event.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Etkinlik Düzenle',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF003875),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Etkinlik Adı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Etkinlik adı gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Açıklama gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Konum',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Konum gerekli' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: ['Eğitim', 'Tatbikat', 'Sosyal', 'Spor']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => selectedCategory = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: maxParticipantsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Maksimum Katılımcı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value?.isEmpty == true) return 'Katılımcı sayısı gerekli';
                  if (int.tryParse(value!) == null) return 'Geçerli bir sayı girin';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  title: const Text('Etkinlik Tarihi'),
                  subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003875),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Etkinlik Güncelle', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updatedEvent = EventModel(
      id: widget.event.id,
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
      location: locationController.text,
      category: selectedCategory,
      maxParticipants: int.parse(maxParticipantsController.text),
      currentParticipants: widget.event.currentParticipants,
      isActive: widget.event.isActive,
      createdAt: widget.event.createdAt,
    );

    final success = await EventService.updateEvent(updatedEvent);
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Etkinlik başarıyla güncellendi!' : 'Hata oluştu'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}

class _EditNewsScreen extends StatefulWidget {
  final NewsModel news;
  
  const _EditNewsScreen({required this.news});

  @override
  State<_EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<_EditNewsScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late final TextEditingController authorController;
  late String selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.news.title);
    contentController = TextEditingController(text: widget.news.content);
    authorController = TextEditingController(text: widget.news.author);
    selectedCategory = widget.news.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Haber Düzenle',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF003875),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Haber Başlığı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Haber başlığı gerekli' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: contentController,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'Haber İçeriği',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) => value?.isEmpty == true ? 'Haber içeriği gerekli' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: ['Genel', 'Arama-Kurtarma', 'Eğitim', 'Tatbikat', 'Sosyal']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) => setState(() => selectedCategory = value!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: authorController,
                decoration: const InputDecoration(
                  labelText: 'Yazar',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Yazar gerekli' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _updateNews,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003875),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Haber Güncelle', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateNews() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updatedNews = NewsModel(
      id: widget.news.id,
      title: titleController.text,
      content: contentController.text,
      category: selectedCategory,
      imageUrl: widget.news.imageUrl,
      publishDate: widget.news.publishDate,
      author: authorController.text,
      isPublished: widget.news.isPublished,
      viewCount: widget.news.viewCount,
      createdAt: widget.news.createdAt,
    );

    final success = await NewsService.updateNews(updatedNews);
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Haber başarıyla güncellendi!' : 'Hata oluştu'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }
}
