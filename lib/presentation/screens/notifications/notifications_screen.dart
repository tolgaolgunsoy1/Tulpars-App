import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _emergencyEnabled = true;
  bool _newsEnabled = true;
  bool _eventsEnabled = true;
  bool _generalEnabled = true;

  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Yeni Eğitim Duyurusu',
      'message': 'İlk Yardım Eğitimi kayıtları başladı. Kontenjan sınırlıdır.',
      'type': 'event',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'isRead': false,
    },
    {
      'id': '2',
      'title': 'Operasyon Güncellemesi',
      'message':
          'Hatay arama kurtarma operasyonunda 3 vatandaş daha kurtarıldı.',
      'type': 'emergency',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': true,
    },
    {
      'id': '3',
      'title': 'Haber: Şampiyona Başarısı',
      'message':
          'Basketbol takımımız bölgesel şampiyonada birincilik elde etti.',
      'type': 'news',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'isRead': true,
    },
    {
      'id': '4',
      'title': 'Genel Kurul Toplantısı',
      'message': '15 Ocak 2025 tarihinde genel kurul toplantısı yapılacaktır.',
      'type': 'general',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': false,
    },
    {
      'id': '5',
      'title': 'Gıda Kampanyası',
      'message':
          'Ramazan ayında ihtiyaç sahibi ailelere gıda dağıtımı başlatıldı.',
      'type': 'news',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(AppConstants.primaryColor),
        elevation: 0,
        title: const Text(
          'Bildirimler',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text(
              'Tümünü Okundu İşaretle',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Notification Settings
            _buildSettingsSection(),

            // Notifications List
            Expanded(
              child: _notifications.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bildirim Ayarları',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            'Acil Durum',
            'Operasyon ve acil durum bildirimleri',
            _emergencyEnabled,
            (value) => setState(() => _emergencyEnabled = value),
            const Color(0xFFDC2626),
          ),
          _buildSettingItem(
            'Haberler',
            'Dernek haberleri ve duyuruları',
            _newsEnabled,
            (value) => setState(() => _newsEnabled = value),
            const Color(0xFFF59E0B),
          ),
          _buildSettingItem(
            'Etkinlikler',
            'Eğitim ve etkinlik duyuruları',
            _eventsEnabled,
            (value) => setState(() => _eventsEnabled = value),
            const Color(0xFF10B981),
          ),
          _buildSettingItem(
            'Genel',
            'Genel bildirimler',
            _generalEnabled,
            (value) => setState(() => _generalEnabled = value),
            const Color(AppConstants.primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getNotificationIcon(title),
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final isUnread = !notification['isRead'];
    final color = _getNotificationColor(notification['type']);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
        border: isUnread
            ? Border.all(color: color.withOpacity(0.3), width: 2)
            : null,
      ),
      child: InkWell(
        onTap: () => _markAsRead(notification['id']),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getNotificationIconFromType(notification['type']),
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  isUnread ? FontWeight.bold : FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'],
                      style: TextStyle(
                        fontSize: 14,
                        color: isUnread
                            ? const Color(0xFF0F172A)
                            : const Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(notification['timestamp']),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              // Action Menu
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'read':
                      _markAsRead(notification['id']);
                      break;
                    case 'delete':
                      _deleteNotification(notification['id']);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (!notification['isRead'])
                    const PopupMenuItem(
                      value: 'read',
                      child: Text('Okundu İşaretle'),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Sil'),
                  ),
                ],
                icon: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Henüz bildirim yok',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yeni bildirimler burada görünecek',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final notification =
          _notifications.firstWhere((n) => n['id'] == notificationId);
      notification['isRead'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tüm bildirimler okundu olarak işaretlendi'),
        backgroundColor: Color(AppConstants.successColor),
      ),
    );
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bildirim silindi'),
        backgroundColor: Color(AppConstants.successColor),
      ),
    );
  }

  IconData _getNotificationIcon(String title) {
    switch (title) {
      case 'Acil Durum':
        return Icons.warning;
      case 'Haberler':
        return Icons.article;
      case 'Etkinlikler':
        return Icons.event;
      case 'Genel':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  IconData _getNotificationIconFromType(String type) {
    switch (type) {
      case 'emergency':
        return Icons.warning;
      case 'news':
        return Icons.article;
      case 'event':
        return Icons.event;
      case 'general':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'emergency':
        return const Color(0xFFDC2626);
      case 'news':
        return const Color(0xFFF59E0B);
      case 'event':
        return const Color(0xFF10B981);
      case 'general':
        return const Color(AppConstants.primaryColor);
      default:
        return const Color(AppConstants.primaryColor);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} dakika önce';
      }
      return '${difference.inHours} saat önce';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else {
      return DateFormat('dd.MM.yyyy').format(timestamp);
    }
  }
}
