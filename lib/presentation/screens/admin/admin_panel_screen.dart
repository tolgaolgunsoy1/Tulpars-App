import 'package:flutter/material.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/user_role.dart';
import '../../../core/services/user_service.dart';

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
                _buildStatsCards(),
                const SizedBox(height: 24),
                _buildUsersSection(),
              ],
            ),
    );
  }

  Widget _buildDemoAdminCard() {
    final credentials = UserService.getDemoAdminCredentials();
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
                  'Demo Admin Hesabı',
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
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '30 gün sonra otomatik devre dışı',
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

  Widget _buildUsersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kullanıcılar',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._users.map((user) => _buildUserCard(user)),
      ],
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
