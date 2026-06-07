// lib/services/company_service.dart
import '../repositories/company_repository.dart';

class CompanyService {
  static final CompanyService _i = CompanyService._();
  CompanyService._();
  factory CompanyService() => _i;

  Future<Map<String, dynamic>?> getCompanyAdmin(int companyId) => CompanyRepository().getAdmin(companyId);
}
