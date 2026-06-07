// lib/screens/learning_hub_screen.dart
import 'package:flutter/material.dart';
import '../services/community_service.dart';

class LearningHubScreen extends StatefulWidget {
  const LearningHubScreen({super.key});
  @override State<LearningHubScreen> createState() => _LearningHubScreenState();
}

class _LearningHubScreenState extends State<LearningHubScreen> {
  Future<List<Map<String, dynamic>>>? _future;

  @override
  void initState() { super.initState(); _future = CommunityService.fetchLearningResources(); }

  IconData _icon(String? name) {
    switch (name) {
      case 'mic':       return Icons.mic;
      case 'handshake': return Icons.handshake;
      case 'keyboard':  return Icons.keyboard;
      case 'gavel':     return Icons.gavel;
      case 'description': return Icons.description;
      default:          return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Learning Hub'),
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
              final items = snap.data?.isNotEmpty == true ? snap.data! : _staticItems();
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  final r = items[i];
                  return _card(r['title'] as String? ?? '',
                      _icon(r['icon_name'] as String?),
                      r['lessons_count'] as String? ?? '');
                },
              );
            },
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _staticItems() => [
    {'title': 'Interview Prep',               'icon_name': 'mic',       'lessons_count': '4 Lessons'},
    {'title': 'Negotiating Accommodations',   'icon_name': 'handshake', 'lessons_count': '2 Lessons'},
    {'title': 'Screen Reader Mastery',        'icon_name': 'keyboard',  'lessons_count': '10 Lessons'},
    {'title': 'Legal Rights (ADA)',           'icon_name': 'gavel',     'lessons_count': 'Readings'},
  ];

  Widget _card(String title, IconData icon, String subtitle) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircleAvatar(radius: 30,
                backgroundColor: Colors.blue.shade50,
                child: Icon(icon, size: 30, color: Colors.blueAccent)),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 5),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ]),
        ),
      ),
    );
  }
}
