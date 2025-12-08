import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isEditing = false;
  bool _isLoading = false;

  // Mock user data - replace with actual user data
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
  };

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    // Initialize controllers with current data
    _nameController.text = _userData['name'];
    _surnameController.text = _userData['surname'];
    _emailController.text = _userData['email'];
    _phoneController.text = _userData['phone'];
    _emergencyContactController.text = _userData['emergencyContact'];
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Update user data
    _userData['name'] = _nameController.text;
    _userData['surname'] = _surnameController.text;
    _userData['email'] = _emailController.text;
    _userData['phone'] = _phoneController.text;
    _userData['emergencyContact'] = _emergencyContactController.text;

    setState(() => _isLoading = false);
    _toggleEdit();

    _showSuccessSnackBar('Profil bilgileriniz güncellendi');
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(AppConstants.successColor),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(AppConstants.primaryColor),
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            color: Colors.white,
            onPressed: _isEditing ? _toggleEdit : _toggleEdit,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(),

              const SizedBox(height: 24),

              // Profile Information
              _buildProfileInfo(),

              const SizedBox(height: 24),

              // Statistics
              _buildStatistics(),

              const SizedBox(height: 24),

              // Menu Items
              _buildMenuItems(),

              const SizedBox(height: 80), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(AppConstants.primaryColor),
            Color(AppConstants.primaryLightColor)
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(AppConstants.primaryColor).withValues(alpha: 77),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Color(AppConstants.primaryColor),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${_userData['name']} ${_userData['surname']}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _userData['email'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 204),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 51),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Üye: ${_userData['memberSince']}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
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
            const Text(
              'Kişisel Bilgiler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
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
            if (_isEditing) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _toggleEdit,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(AppConstants.primaryColor)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
  }) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      enabled: _isEditing && enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
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
        const Text(
          'İstatistikler',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Toplam Bağış',
                value: _userData['totalDonations'],
                icon: Icons.volunteer_activism,
                color: const Color(0xFFDC2626),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Operasyon',
                value: '${_userData['operationsParticipated']}',
                icon: Icons.search,
                color: const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Eğitim',
                value: '${_userData['trainingsCompleted']}',
                icon: Icons.school,
                color: const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Üyelik',
                value: '${_userData['memberSince']}',
                icon: Icons.calendar_today,
                color: const Color(AppConstants.primaryColor),
              ),
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
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItems() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Bildirimler',
            onTap: () {
              // TODO: Navigate to notifications settings
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Gizlilik',
            onTap: () {
              // TODO: Navigate to privacy settings
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Yardım & Destek',
            onTap: () {
              // TODO: Navigate to help screen
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'Hakkında',
            onTap: () {
              // TODO: Navigate to about screen
            },
          ),
          const Divider(height: 1),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(AppConstants.primaryColor)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Color(0xFFDC2626)),
        title: const Text(
          'Çıkış Yap',
          style: TextStyle(color: Color(0xFFDC2626)),
        ),
        onTap: () {
          // TODO: Implement logout
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Çıkış Yap'),
              content: const Text(
                  'Hesabınızdan çıkış yapmak istediğinizden emin misiniz?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('İptal'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: Implement actual logout
                    Navigator.of(context).pushReplacementNamed('/');
                  },
                  child: const Text(
                    'Çıkış',
                    style: TextStyle(color: Color(0xFFDC2626)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
