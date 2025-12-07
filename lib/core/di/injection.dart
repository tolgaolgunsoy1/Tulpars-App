import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../services/auth_service.dart';
import '../services/cache_service.dart';
import '../services/connectivity_service.dart';
import '../services/notification_service.dart';
import '../services/secure_storage_service.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void configureDependencies() => $initGetIt(getIt);

@module
abstract class RegisterModule {
  @singleton
  AuthService get authService => AuthService();

  @singleton
  CacheService get cacheService => CacheService();

  @singleton
  ConnectivityService get connectivityService => ConnectivityService();

  @singleton
  NotificationService get notificationService => NotificationService();

  @singleton
  SecureStorageService get secureStorageService => SecureStorageService();
}

