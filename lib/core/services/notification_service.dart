import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/app_constants.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Request permission for iOS
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    ); // Initialize local notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    ); // Create notification channels for Android
    await _createNotificationChannels();

    // Listen to FCM messages
    FirebaseMessaging.onMessage.listen(_onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _isInitialized = true;
  }

  Future<void> _createNotificationChannels() async {
    const emergencyChannel = AndroidNotificationChannel(
      AppConstants.emergencyChannelId,
      'Acil Durum',
      description: 'Acil durum ve operasyon bildirimleri',
      importance: Importance.max,
    );
    const newsChannel = AndroidNotificationChannel(
      AppConstants.newsChannelId,
      'Haberler',
      description: 'Dernek haberleri ve duyuruları',
      importance: Importance.high,
    );
    const eventsChannel = AndroidNotificationChannel(
      AppConstants.eventsChannelId,
      'Etkinlikler',
      description: 'Etkinlik ve eğitim duyuruları',
      importance: Importance.defaultImportance,
    );
    const generalChannel = AndroidNotificationChannel(
      AppConstants.generalChannelId,
      'Genel',
      description: 'Genel bildirimler',
      importance: Importance.low,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(emergencyChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(newsChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(eventsChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(generalChannel);
  }

  void _onMessageReceived(RemoteMessage message) {
    _showLocalNotification(message);
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    // Handle notification tap when app is opened from background
    _handleNotificationTap(message);
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle local notification tap
    final payload = response.payload;
    if (payload != null) {
      // Navigate based on payload
      _handleNotificationTapFromPayload(payload);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    if (notification == null) return;

    var channelId = AppConstants.generalChannelId;

    // Determine channel based on data
    if (data.containsKey('type')) {
      switch (data['type']) {
        case 'emergency':
          channelId = AppConstants.emergencyChannelId;
          break;
        case 'news':
          channelId = AppConstants.newsChannelId;
          break;
        case 'event':
          channelId = AppConstants.eventsChannelId;
          break;
      }
    }

    const androidDetails = AndroidNotificationDetails(
      'general_channel',
      'Genel',
      channelDescription: 'Genel bildirimler',
      importance: Importance.max,
      showWhen: true,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      notification.title,
      notification.body,
      details,
      payload: data['route'] ?? data.toString(),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    _handleNotificationTapFromPayload(data['route'] ?? data.toString());
  }

  void _handleNotificationTapFromPayload(String payload) {
    // This would typically navigate to specific screens
    // For now, we'll just print the payload
    print('Notification tapped with payload: $payload');
  }

  // Get FCM token
  Future<String?> getFCMToken() async {
    return _firebaseMessaging.getToken();
  }

  // Subscribe to topics
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  // Unsubscribe from topics
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  // Show local notification
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = 'general_channel',
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'general_channel',
      'Genel',
      channelDescription: 'Genel bildirimler',
      importance: Importance.max,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // Get initial message (when app is opened from terminated state)
  Future<RemoteMessage?> getInitialMessage() async {
    return _firebaseMessaging.getInitialMessage();
  }
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
  // Handle background messages here
}


