// lib/services/auth_service.dart
// DESIGN PATTERN: Singleton + Service Layer (sits between UI and Repository)
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/auth_repository.dart';

class AuthService {
  static final AuthService _i = AuthService._();
  AuthService._();
  factory AuthService() => _i;

  Future<bool> register(String email, String password, String role, {String? companyName}) =>
      AuthRepository().register(email, password, role, companyName: companyName);

  Future<bool> login(String email, String password) async {
    final data = await AuthRepository().login(email, password);
    if (data == null) return false;
    final prefs = await SharedPreferences.getInstance();
    final user  = data['user'] as Map<String, dynamic>;
    await prefs.setString('token',     data['token'] as String? ?? '');
    await prefs.setInt   ('userId',    user['id'] as int);
    await prefs.setString('role',      user['role'] as String);
    await prefs.setString('userEmail', user['email'] as String);
    await prefs.setString('userName',  user['name'] as String? ?? 'User');
    if (user['companyId'] != null) await prefs.setInt('companyId', user['companyId'] as int);
    if (user['role'] == 'employer')   await prefs.setInt('employerId', user['id'] as int);
    return true;
  }

  Future<void> logout() async => (await SharedPreferences.getInstance()).clear();
}
