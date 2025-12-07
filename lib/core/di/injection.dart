import 'package:get_it/get_it.dart';

import '../services/auth_service.dart';
import '../services/cache_service.dart';
import '../services/connectivity_service.dart';
import '../services/notification_service.dart';
import '../services/secure_storage_service.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Register services as singletons
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<CacheService>(() => CacheService());
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService());
}
