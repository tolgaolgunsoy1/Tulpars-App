import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for secure storage of sensitive data
class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Keys for different types of data
  static const String _authTokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userProfileKey = 'user_profile';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _themeModeKey = 'theme_mode';
  static const String _languageKey = 'language';

  /// Save authentication token
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    return _storage.read(key: _authTokenKey);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return _storage.read(key: _userIdKey);
  }

  /// Save user profile data
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    final profileJson = jsonEncode(profile);
    await _storage.write(key: _userProfileKey, value: profileJson);
  }

  /// Get user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    final profileJson = await _storage.read(key: _userProfileKey);
    if (profileJson != null) {
      return jsonDecode(profileJson) as Map<String, dynamic>;
    }
    return null;
  }

  /// Save biometric authentication preference
  Future<void> saveBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _biometricEnabledKey,
      value: enabled.toString(),
    );
  }

  /// Get biometric authentication preference
  Future<bool> getBiometricEnabled() async {
    final value = await _storage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  /// Save theme mode preference
  Future<void> saveThemeMode(String themeMode) async {
    await _storage.write(key: _themeModeKey, value: themeMode);
  }

  /// Get theme mode preference
  Future<String?> getThemeMode() async {
    return _storage.read(key: _themeModeKey);
  }

  /// Save language preference
  Future<void> saveLanguage(String languageCode) async {
    await _storage.write(key: _languageKey, value: languageCode);
  }

  /// Get language preference
  Future<String?> getLanguage() async {
    return _storage.read(key: _languageKey);
  }

  /// Save custom key-value pair
  Future<void> saveCustomData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Get custom data by key
  Future<String?> getCustomData(String key) async {
    return _storage.read(key: key);
  }

  /// Delete specific data
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete authentication data
  Future<void> deleteAuthData() async {
    await _storage.delete(key: _authTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
  }

  /// Delete all user data
  Future<void> deleteAllUserData() async {
    await _storage.deleteAll();
  }

  /// Check if data exists for a key
  Future<bool> containsKey(String key) async {
    return _storage.containsKey(key: key);
  }

  /// Get all stored keys (for debugging)
  Future<Set<String>> getAllKeys() async {
    final allData = await _storage.readAll();
    return allData.keys.toSet();
  }

  /// Clear all data except specified keys
  Future<void> clearExcept(List<String> keepKeys) async {
    final allData = await _storage.readAll();
    for (final key in allData.keys) {
      if (!keepKeys.contains(key)) {
        await _storage.delete(key: key);
      }
    }
  }

  /// Encrypt and save sensitive data
  Future<void> saveEncryptedData(String key, String data) async {
    // In a real implementation, you would encrypt the data here
    // For now, we're relying on FlutterSecureStorage's built-in encryption
    await _storage.write(key: key, value: data);
  }

  /// Decrypt and get sensitive data
  Future<String?> getEncryptedData(String key) async {
    // In a real implementation, you would decrypt the data here
    return _storage.read(key: key);
  }
}
