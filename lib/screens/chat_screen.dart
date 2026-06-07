// lib/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/message_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late int _myId, _otherId;
  String? _otherName;
  int?    _jobId;
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;
  final _msgCtrl = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['otherUserId'] != null) {
      _otherId   = args['otherUserId']   as int;
      _otherName = args['otherUserName'] as String?;
      _jobId     = args['jobId']         as int?;
      _init();
    } else {
      Future.microtask(() => Navigator.maybePop(context));
    }
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final id    = prefs.getInt('userId');
    if (id == null) { Navigator.pop(context); return; }
    _myId = id;
    await _load();
  }

  Future<void> _load() async {
    final msgs = await MessageService().getConversation(
        userId: _myId, otherUserId: _otherId, jobId: _jobId);
    setState(() { _messages = msgs; _loading = false; });
  }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    final ok = await MessageService().sendMessage(
        senderId: _myId, receiverId: _otherId, content: text, jobId: _jobId);
    if (ok) { _msgCtrl.clear(); await _load(); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_otherName ?? 'Chat'),
          actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)]),
      body: Column(children: [
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _messages.isEmpty
                  ? const Center(child: Text('Start the conversation!'))
                  : ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (ctx, i) {
                        final m   = _messages[i];
                        final isMe = m['sender_id'] == _myId;
                        return _bubble(m, isMe);
                      }),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _msgCtrl,
                decoration: const InputDecoration(
                    hintText: 'Type a message…', border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
                icon: const Icon(Icons.send, color: Colors.blueAccent),
                onPressed: _send),
          ]),
        ),
      ]),
    );
  }

  Widget _bubble(Map<String, dynamic> m, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
            color: isMe ? Colors.blue.shade100 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (!isMe) Text(m['sender_name'] ?? 'User',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text(m['content'] ?? ''),
          const SizedBox(height: 4),
          Text(DateTime.parse(m['sent_at']).toLocal().toString().substring(11, 16),
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ]),
      ),
    );
  }
}
