import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  final String _language = 'Türkçe';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        backgroundColor: const Color(0xFF003875),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Bildirimler'),
          SwitchListTile(
            title: const Text('Bildirimleri Etkinleştir'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          const Divider(),
          _buildSectionHeader('Görünüm'),
          SwitchListTile(
            title: const Text('Koyu Mod'),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() => _darkModeEnabled = value);
            },
          ),
          const Divider(),
          _buildSectionHeader('Dil'),
          ListTile(
            title: const Text('Dil Seçimi'),
            subtitle: Text(_language),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Show language selection
            },
          ),
          const Divider(),
          _buildSectionHeader('Hesap'),
          ListTile(
            title: const Text('Şifre Değiştir'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navigate to change password
            },
          ),
          ListTile(
            title: const Text('Hesabı Sil'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Show delete account dialog
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF003875),
        ),
      ),
    );
  }
}
