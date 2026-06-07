// lib/providers/notification_provider.dart
// DESIGN PATTERN: Observer Pattern
// CommunityNotificationProvider is the Subject. Any widget that calls
// addNotification() causes all listening widgets to rebuild automatically.
import 'package:flutter/material.dart';

class CommunityNotificationProvider extends ChangeNotifier {
  // Singleton so all screens share the same state
  static final CommunityNotificationProvider _i = CommunityNotificationProvider._();
  CommunityNotificationProvider._();
  factory CommunityNotificationProvider() => _i;

  int _unreadCount = 0;
  final List<String> _notifications = [];

  int          get unreadCount    => _unreadCount;
  List<String> get notifications  => List.unmodifiable(_notifications);

  /// Called when an event happens (e.g. mentorship request sent).
  /// Notifies all Observer widgets automatically via ChangeNotifier.
  void addNotification(String message) {
    _notifications.insert(0, message);
    _unreadCount++;
    notifyListeners(); // ← Observer broadcast
  }

  void clearBadge() {
    _unreadCount = 0;
    notifyListeners();
  }
}
