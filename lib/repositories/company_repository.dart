// lib/repositories/company_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class CompanyRepository {
  static final CompanyRepository _i = CompanyRepository._();
  CompanyRepository._();
  factory CompanyRepository() => _i;

  Future<Map<String, dynamic>?> getAdmin(int companyId) async {
    final res = await http.get(Uri.parse('${AppConstants.baseUrl}/companies/$companyId/admin'));
    if (res.statusCode == 200) return jsonDecode(res.body) as Map<String, dynamic>;
    return null;
  }
}
