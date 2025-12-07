class AppConstants {
  // App Information
  static const String appName = 'Tulpars Derneği';
  static const String appVersion = '1.0.0';
  static const String websiteUrl = 'https://www.tulpars.org.tr/';

  // API Endpoints (if needed)
  static const String baseUrl = 'https://api.tulpars.org.tr';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String newsCollection = 'news';
  static const String eventsCollection = 'events';
  static const String operationsCollection = 'operations';
  static const String donationsCollection = 'donations';
  static const String trainingsCollection = 'trainings';
  static const String sportsCollection = 'sports';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String newsImagesPath = 'news_images';
  static const String eventImagesPath = 'event_images';
  static const String operationImagesPath = 'operation_images';
  static const String galleryPath = 'gallery';

  // Emergency Numbers
  static const String emergencyNumber = '112';
  static const String fireNumber = '110';
  static const String policeNumber = '155';
  static const String tulparsEmergency = '+90 123 456 7890';

  // Social Media Links
  static const String facebookUrl = 'https://facebook.com/tulpars';
  static const String instagramUrl = 'https://instagram.com/tulpars';
  static const String twitterUrl = 'https://twitter.com/tulpars';
  static const String youtubeUrl = 'https://youtube.com/tulpars';

  // Colors - Updated Tulpars Brand Colors
  static const int primaryColor = 0xFF003875; // Primary Blue
  static const int primaryLightColor = 0xFF0055A5; // Primary Light
  static const int primaryDarkColor = 0xFF001F3F; // Primary Dark
  static const int secondaryColor = 0xFFDC2626; // Emergency Red
  static const int accentColor = 0xFFF59E0B; // Accent Orange
  static const int successColor = 0xFF10B981; // Success Green
  static const int backgroundColor = 0xFFF8FAFC; // Background
  static const int surfaceColor = 0xFFFFFFFF; // Surface
  static const int darkBackgroundColor = 0xFF1E293B; // Dark Background
  static const int primaryTextColor = 0xFF0F172A; // Primary Text
  static const int secondaryTextColor = 0xFF64748B; // Secondary Text
  static const int disabledColor = 0xFFCBD5E1; // Disabled

  // Dimensions
  static const double defaultPadding = 16;
  static const double defaultBorderRadius = 8;
  static const double defaultElevation = 4;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 1000);

  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 24);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',];static const List<String> allowedVideoExtensions = ['mp4', 'mov', 'avi'];

  // Location
  static const double defaultLatitude = 39.9208; // Kayseri, Turkey
  static const double defaultLongitude =
      32.8541; // Ankara, Turkey (adjust as needed)
  static const double defaultZoom = 10;

  // Notification Channels
  static const String emergencyChannelId = 'emergency';
  static const String newsChannelId = 'news';
  static const String eventsChannelId = 'events';
  static const String generalChannelId = 'general';
}




