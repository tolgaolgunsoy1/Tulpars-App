import 'package:get_it/get_it.dart';

import '../services/auth_service.dart';
import '../services/cache_service.dart';
import '../services/connectivity_service.dart';
import '../services/notification_service.dart';
import '../services/secure_storage_service.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  // Register services as singletons
  getIt
    ..registerLazySingleton<AuthService>(AuthService.new)
    ..registerLazySingleton<CacheService>(CacheService.new)
    ..registerLazySingleton<ConnectivityService>(ConnectivityService.new)
    ..registerLazySingleton<NotificationService>(NotificationService.new)
    ..registerLazySingleton<SecureStorageService>(SecureStorageService.new);
}
