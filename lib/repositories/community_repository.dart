// lib/repositories/community_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class CommunityRepository {
  static final CommunityRepository _i = CommunityRepository._();
  CommunityRepository._();
  factory CommunityRepository() => _i;

  Future<List<Map<String, dynamic>>> fetchLearning() async {
    final res = await http.get(Uri.parse('${AppConstants.baseUrl}/community/learning'));
    if (res.statusCode == 200) return List<Map<String, dynamic>>.from(jsonDecode(res.body) as List);
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchMentors() async {
    final res = await http.get(Uri.parse('${AppConstants.baseUrl}/community/mentors'));
    if (res.statusCode == 200) return List<Map<String, dynamic>>.from(jsonDecode(res.body) as List);
    return [];
  }

  Future<List<Map<String, dynamic>>> fetchForum() async {
    final res = await http.get(Uri.parse('${AppConstants.baseUrl}/community/forum'));
    if (res.statusCode == 200) return List<Map<String, dynamic>>.from(jsonDecode(res.body) as List);
    return [];
  }

  Future<Map<String, dynamic>> requestMentorship(int seekerId, int mentorId, String message) async {
    final res = await http.post(Uri.parse('${AppConstants.baseUrl}/community/mentorship-request'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'seeker_id': seekerId, 'mentor_id': mentorId, 'message': message}));
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return {'success': res.statusCode == 201, 'message': data['message'] ?? ''};
  }
}
