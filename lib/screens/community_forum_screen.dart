// lib/screens/community_forum_screen.dart
import 'package:flutter/material.dart';
import '../services/community_service.dart';

class CommunityForumScreen extends StatefulWidget {
  const CommunityForumScreen({super.key});
  @override State<CommunityForumScreen> createState() => _CommunityForumScreenState();
}

class _CommunityForumScreenState extends State<CommunityForumScreen> {
  Future<List<Map<String, dynamic>>>? _future;

  @override
  void initState() { super.initState(); _future = CommunityService.fetchForumPosts(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Community Forum'),
          backgroundColor: Colors.blueAccent, foregroundColor: Colors.white,
          actions: [
            IconButton(icon: const Icon(Icons.report_gmailerrorred),
                onPressed: () => Navigator.pushNamed(context, '/report')),
            IconButton(icon: const Icon(Icons.account_circle),
                onPressed: () => Navigator.pushNamed(context, '/profile')),
          ]),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _future,
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final posts = snap.data?.isNotEmpty == true ? snap.data! : _staticPosts();
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (ctx, i) {
                  final p = posts[i];
                  return _postCard(p['title'] as String? ?? '',
                      p['category'] as String? ?? 'General',
                      (p['upvotes'] as int?) ?? 0,
                      (p['replies'] as int?) ?? (p['replies_count'] as int?) ?? 0);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _staticPosts() => [
    {'title': 'Best ergonomic chairs for long hours?', 'category': 'General', 'upvotes': 45, 'replies': 12},
    {'title': 'Companies with great neurodivergent policies', 'category': 'Careers', 'upvotes': 120, 'replies': 34},
    {'title': 'How to request a sign language interpreter?', 'category': 'Advice', 'upvotes': 88, 'replies': 15},
  ];

  Widget _postCard(String title, String category, int upvotes, int replies) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Chip(label: Text(category, style: const TextStyle(fontSize: 10)),
              padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.grey),
            const SizedBox(width: 5),
            Text('$upvotes', style: const TextStyle(color: Colors.grey)),
            const SizedBox(width: 15),
            const Icon(Icons.comment_outlined, size: 16, color: Colors.grey),
            const SizedBox(width: 5),
            Text('$replies replies', style: const TextStyle(color: Colors.grey)),
          ]),
        ]),
      ),
    );
  }
}
