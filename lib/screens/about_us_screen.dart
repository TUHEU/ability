// lib/screens/about_us_screen.dart
import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const List<Map<String, String>> _team = [
    {'name': 'YOUNGA TCHAPPI DYLANE',      'role': 'Project Manager & Backend Developer', 'image': 'assets/dylane.jpg',
     'bio': 'Passionate about building inclusive technology and connecting people.'},
    {'name': 'TCHIGUI MAKOUFEU SHELA',     'role': 'Lead Backend Developer',              'image': 'assets/soft.jpg',
     'bio': 'Designs beautiful, accessible, and user-friendly interfaces.'},
    {'name': 'MBANGUE TSHUNGBOVE MARIE',   'role': 'Frontend Flutter Engineer',           'image': 'assets/marie.jpg',
     'bio': 'Turns designs into smooth, functional mobile applications.'},
    {'name': 'BIHINA DIBANJO TONY',        'role': 'Database Administrator',              'image': 'assets/tony.jpg',
     'bio': 'Ensures all user data is secure, fast, and reliable.'},
    {'name': 'NIMBA CARREL',               'role': 'Quality Assurance & Testing',         'image': 'assets/carel.jpg',
     'bio': 'Squashes bugs and ensures the app runs perfectly on all devices.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About the Team'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _team.length,
        itemBuilder: (ctx, i) {
          final m = _team[i];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(children: [
                Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
                  child: ClipOval(child: Image.asset(m['image']!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.person, size: 40, color: Colors.grey))),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(m['name']!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(m['role']!,
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(m['bio']!, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                ])),
              ]),
            ),
          );
        },
      ),
    );
  }
}
