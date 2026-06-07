// lib/core/constants.dart
// DESIGN PATTERN: Singleton-style constants — change server IP in ONE place.
class AppConstants {
  AppConstants._();

  // ✅ Change this to your machine's LAN IP when running on a physical device
  static const String serverIp = '192.168.1.191';
  static const String baseUrl = 'http://$serverIp:3000/api';
  static const String appName = 'AbilityBridge';
  static const String appVersion = '1.0.0';
}
