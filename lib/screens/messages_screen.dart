// lib/screens/messages_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/message_service.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});
  @override State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late int _myId;
  List<Map<String, dynamic>> _convos = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _init(); }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final id    = prefs.getInt('userId');
    if (id == null) { Navigator.pop(context); return; }
    _myId = id;
    await _fetch();
  }

  Future<void> _fetch() async {
    final convos = await MessageService().getUserConversations(_myId);
    setState(() { _convos = convos; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _convos.isEmpty
              ? const Center(child: Text('No conversations yet.'))
              : ListView.builder(
                  itemCount: _convos.length,
                  itemBuilder: (ctx, i) {
                    final c    = _convos[i];
                    final name = c['other_user_name'] as String? ?? 'Unknown';
                    final last = c['last_message']    as String? ?? '';
                    final time = c['last_message_time'] != null
                        ? DateTime.parse(c['last_message_time'] as String)
                            .toLocal().toString().substring(0, 16)
                        : '';
                    return Card(
                      elevation: 0,
                      color: Colors.blue.shade50,
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Text(name.isNotEmpty ? name[0] : '?',
                                style: const TextStyle(color: Colors.white))),
                        title: Text(name,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(last, maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        trailing: Text(time,
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        onTap: () => Navigator.pushNamed(ctx, '/chat', arguments: {
                          'otherUserId':   c['other_user_id'],
                          'otherUserName': name,
                        }),
                      ),
                    );
                  }),
    );
  }
}
