// lib/services/message_service.dart
import '../repositories/message_repository.dart';

class MessageService {
  static final MessageService _i = MessageService._();
  MessageService._();
  factory MessageService() => _i;

  Future<bool> sendMessage({required int senderId, required int receiverId, required String content, int? jobId}) =>
      MessageRepository().send(senderId, receiverId, content, jobId: jobId);

  Future<List<Map<String, dynamic>>> getConversation({required int userId, required int otherUserId, int? jobId}) =>
      MessageRepository().getConversation(userId, otherUserId, jobId: jobId);

  Future<List<Map<String, dynamic>>> getUserConversations(int userId) =>
      MessageRepository().getConversations(userId);
}
