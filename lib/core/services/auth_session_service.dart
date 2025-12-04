import 'package:shared_preferences/shared_preferences.dart';

/// Authentication service for managing user sessions
class AuthSessionService {
  static const String _keyIsAuthenticated = 'is_authenticated';
  static const String _keyPhoneNumber = 'phone_number';
  static const String _keyUserId = 'user_id';
  static const String _keyLoginTimestamp = 'login_timestamp';
  static const int _sessionDurationHours = 24; // Session expires after 24 hours

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAuth = prefs.getBool(_keyIsAuthenticated) ?? false;
      
      if (!isAuth) return false;

      // Check session expiry
      final timestamp = prefs.getInt(_keyLoginTimestamp);
      if (timestamp == null) return false;

      final loginTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(loginTime);

      // Session expired
      if (difference.inHours >= _sessionDurationHours) {
        await logout();
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Save user session after successful login
  Future<void> saveSession({
    required String phoneNumber,
    String? userId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsAuthenticated, true);
      await prefs.setString(_keyPhoneNumber, phoneNumber);
      if (userId != null) {
        await prefs.setString(_keyUserId, userId);
      }
      await prefs.setInt(_keyLoginTimestamp, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw Exception('Failed to save session: $e');
    }
  }

  /// Get current user phone number
  Future<String?> getUserPhoneNumber() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyPhoneNumber);
    } catch (e) {
      return null;
    }
  }

  /// Get current user ID
  Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserId);
    } catch (e) {
      return null;
    }
  }

  /// Logout user and clear session
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyIsAuthenticated);
      await prefs.remove(_keyPhoneNumber);
      await prefs.remove(_keyUserId);
      await prefs.remove(_keyLoginTimestamp);
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  /// Refresh session timestamp
  Future<void> refreshSession() async {
    try {
      final isAuth = await isAuthenticated();
      if (isAuth) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(_keyLoginTimestamp, DateTime.now().millisecondsSinceEpoch);
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Get remaining session time in hours
  Future<int> getRemainingSessionHours() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_keyLoginTimestamp);
      if (timestamp == null) return 0;

      final loginTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(loginTime);
      final remaining = _sessionDurationHours - difference.inHours;

      return remaining > 0 ? remaining : 0;
    } catch (e) {
      return 0;
    }
  }
}
