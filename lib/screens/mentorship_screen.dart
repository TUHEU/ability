// lib/screens/mentorship_screen.dart
// DESIGN PATTERN: Observer Pattern — writes to CommunityNotificationProvider
//                 Template Method — extends AbilityScreen
import 'package:flutter/material.dart';
import '../app_components.dart';
import '../services/community_service.dart';
import '../providers/notification_provider.dart';

class MentorshipScreen extends AbilityScreen {
  const MentorshipScreen() : super('Mentorship');

  Future<List<Map<String, dynamic>>> _fetchMentors() => CommunityService.fetchMentors();

  @override
  Widget buildBody(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchMentors(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final mentors = snap.data?.isNotEmpty == true ? snap.data! : _staticMentors();
        return ListView.builder(
          itemCount: mentors.length,
          itemBuilder: (ctx, i) {
            final m = mentors[i];
            return _mentorCard(context, m['name'] as String? ?? 'Mentor',
                m['role'] as String? ?? 'Professional',
                m['tag'] as String? ?? m['expertise'] as String? ?? 'General',
                m['exp'] as String? ?? m['experience'] as String? ?? '',
                m['id'] as int?);
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> _staticMentors() => [
    {'name': 'Alex Rivera',  'role': 'Senior Dev @ Microsoft', 'tag': 'Blind/Low Vision',   'exp': '10 yrs', 'id': null},
    {'name': 'Jamie Smith',  'role': 'HR Director',            'tag': 'Wheelchair User',     'exp': '15 yrs', 'id': null},
    {'name': 'Taylor Doe',   'role': 'UX Designer',            'tag': 'Neurodivergent',      'exp': '5 yrs',  'id': null},
  ];

  Widget _mentorCard(BuildContext ctx, String name, String role, String tag, String exp, int? mentorId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const CircleAvatar(radius: 25,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white)),
            const SizedBox(width: 15),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(role, style: const TextStyle(color: Colors.grey)),
            ]),
          ]),
          const SizedBox(height: 15),
          Row(children: [
            Chip(label: Text(tag), backgroundColor: Colors.blue.shade50),
            const SizedBox(width: 10),
            Text(exp, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          ]),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: mentorId == null ? null : () async {
                final messenger = ScaffoldMessenger.of(ctx);
                final result    = await CommunityService.requestMentorship(mentorId);
                if (ctx.mounted) {
                  messenger.showSnackBar(SnackBar(
                      content: Text(result['message'] as String? ?? ''),
                      backgroundColor: result['success'] == true ? Colors.green : Colors.red));
                  // OBSERVER: broadcast notification to all listeners
                  if (result['success'] == true) {
                    CommunityNotificationProvider().addNotification(
                        'Mentorship request sent to $name!');
                  }
                }
              },
              child: const Text('Request Mentorship'),
            ),
          ),
        ]),
      ),
    );
  }
}
