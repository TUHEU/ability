// lib/repositories/message_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class MessageRepository {
  static final MessageRepository _i = MessageRepository._();
  MessageRepository._();
  factory MessageRepository() => _i;

  Future<bool> send(int senderId, int receiverId, String content, {int? jobId}) async {
    final res = await http.post(Uri.parse('${AppConstants.baseUrl}/messages'),
        headers: await _auth(),
        body: jsonEncode({'sender_id': senderId, 'receiver_id': receiverId, 'job_id': jobId, 'content': content}));
    return res.statusCode == 201;
  }

  Future<List<Map<String, dynamic>>> getConversation(int userId, int otherUserId, {int? jobId}) async {
    final params = {'userId': '$userId', 'otherUserId': '$otherUserId', if (jobId != null) 'jobId': '$jobId'};
    final uri = Uri.parse('${AppConstants.baseUrl}/messages/conversation').replace(queryParameters: params);
    final res = await http.get(uri, headers: await _auth());
    if (res.statusCode == 200) return (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
    return [];
  }

  Future<List<Map<String, dynamic>>> getConversations(int userId) async {
    final res = await http.get(Uri.parse('${AppConstants.baseUrl}/messages/conversations?userId=$userId'),
        headers: await _auth());
    if (res.statusCode == 200) return (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
    return [];
  }

  Future<Map<String, String>> _auth() async {
    final prefs = await SharedPreferences.getInstance();
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer ${prefs.getString('token') ?? ''}'};
  }
}
