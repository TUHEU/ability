// lib/repositories/job_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/job_listing.dart';

class JobRepository {
  static final JobRepository _i = JobRepository._();
  JobRepository._();
  factory JobRepository() => _i;

  Future<List<JobListing>> fetchAll() async {
    final res = await http.get(Uri.parse('${AppConstants.baseUrl}/jobs'));
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((j) => JobListing.fromJson(j)).toList();
    }
    return [];
  }

  Future<bool> post(Map<String, dynamic> payload) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/jobs'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<Map<String, dynamic>> fetchEmployerDashboard(int employerId) async {
    final res = await http.get(Uri.parse('${AppConstants.baseUrl}/employers/dashboard/$employerId'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return {
        'stats': data['stats'],
        'jobs': (data['jobs'] as List).map((j) => JobListing.fromJson(j)).toList(),
      };
    }
    return {'stats': {'totalPosts': 0, 'totalApps': 0, 'interviews': 0}, 'jobs': <JobListing>[]};
  }
}
