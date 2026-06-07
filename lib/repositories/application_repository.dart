// lib/repositories/application_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../models/application.dart';

class ApplicationRepository {
  static final ApplicationRepository _i = ApplicationRepository._();
  ApplicationRepository._();
  factory ApplicationRepository() => _i;

  Future<bool> apply(int jobId, int seekerId) async {
    final res = await http.post(
      Uri.parse('${AppConstants.baseUrl}/applications'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'job_id': jobId, 'seeker_id': seekerId}),
    );
    return res.statusCode == 201;
  }

  Future<List<Application>> forJob(int jobId) async {
    final res = await http.get(Uri.parse('${AppConstants.baseUrl}/applications/job/$jobId'),
        headers: await _auth());
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((j) => Application.fromJson(j)).toList();
    }
    return [];
  }

  Future<List<Application>> forSeeker(int seekerId) async {
    final res = await http.get(Uri.parse('${AppConstants.baseUrl}/applications/seeker/$seekerId'),
        headers: await _auth());
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List).map((j) => Application.fromJson(j)).toList();
    }
    return [];
  }

  Future<bool> updateStatus(int applicationId, String status) async {
    final res = await http.put(
      Uri.parse('${AppConstants.baseUrl}/applications/$applicationId/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );
    return res.statusCode == 200;
  }

  Future<Map<String, String>> _auth() async {
    final prefs = await SharedPreferences.getInstance();
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer ${prefs.getString('token') ?? ''}'};
  }
}
