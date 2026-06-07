// lib/services/job_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../models/job_listing.dart';
import '../repositories/job_repository.dart';

class JobService {
  static final JobService _i = JobService._();
  JobService._();
  factory JobService() => _i;

  Future<List<JobListing>> fetchJobs() => JobRepository().fetchAll();

  Future<bool> postJob(JobListing job) async {
    final prefs     = await SharedPreferences.getInstance();
    final companyId = job.companyId ?? prefs.getInt('companyId') ?? 0;
    if (companyId == 0) return false;
    return JobRepository().post({
      'company_id':  companyId,
      'employer_id': prefs.getInt('employerId'),
      'employer_email': prefs.getString('userEmail') ?? '',
      'title':       job.title,
      'description': job.description,
      'job_type':    job.jobType,
      'is_remote':   job.isRemote ? 1 : 0,
      'accommodation_offerings': job.accommodations ?? {},
    });
  }

  Future<Map<String, dynamic>> fetchEmployerDashboard(int employerId) =>
      JobRepository().fetchEmployerDashboard(employerId);
}
