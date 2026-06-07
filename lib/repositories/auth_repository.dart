// lib/repositories/auth_repository.dart
// DESIGN PATTERN: Repository Pattern — abstracts HTTP from business logic
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class AuthRepository {
  static final AuthRepository _instance = AuthRepository._();
  AuthRepository._();
  factory AuthRepository() => _instance;

  Future<bool> register(String email, String password, String role, {String? companyName}) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password, 'role': role, 'companyName': companyName}),
    );
    return res.statusCode == 201;
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    return null;
  }
}
