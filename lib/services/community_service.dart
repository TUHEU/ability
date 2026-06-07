// lib/services/community_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/community_repository.dart';

class CommunityService {
  static Future<List<Map<String, dynamic>>> fetchLearningResources() => CommunityRepository().fetchLearning();
  static Future<List<Map<String, dynamic>>> fetchMentors()           => CommunityRepository().fetchMentors();
  static Future<List<Map<String, dynamic>>> fetchForumPosts()        => CommunityRepository().fetchForum();

  static Future<Map<String, dynamic>> requestMentorship(int mentorId, {String message = ''}) async {
    final prefs    = await SharedPreferences.getInstance();
    final seekerId = prefs.getInt('userId');
    if (seekerId == null) return {'success': false, 'message': 'Please login first.'};
    return CommunityRepository().requestMentorship(seekerId, mentorId, message);
  }
}
