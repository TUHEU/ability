// lib/services/application_service.dart
import '../models/application.dart';
import '../repositories/application_repository.dart';

class ApplicationService {
  static final ApplicationService _i = ApplicationService._();
  ApplicationService._();
  factory ApplicationService() => _i;

  Future<bool> applyToJob(int jobId, int seekerId) => ApplicationRepository().apply(jobId, seekerId);
  Future<List<Application>> getJobApplications(int jobId) => ApplicationRepository().forJob(jobId);
  Future<List<Application>> getSeekerApplications(int seekerId) => ApplicationRepository().forSeeker(seekerId);
  Future<bool> updateApplicationStatus({required int applicationId, required String status}) =>
      ApplicationRepository().updateStatus(applicationId, status);
}
