// lib/screens/impact_report_screen.dart
// DESIGN PATTERN: Template Method (extends AbilityScreen)
import 'package:flutter/material.dart';
import '../app_components.dart';

class ImpactReportScreen extends AbilityScreen {
  const ImpactReportScreen() : super('My Impact Report');

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        const Icon(Icons.emoji_events, size: 80, color: Colors.orange),
        const SizedBox(height: 10),
        const Text('Great Job!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const Text('Here is your journey so far.',
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          StatBox('32', 'Jobs Applied', Colors.blueAccent),
          StatBox('5',  'Interviews',   Colors.green),
        ]),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          StatBox('12', 'Forum Posts',  Colors.purple),
          StatBox('3',  'Courses Done', Colors.orange),
        ]),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.blue.shade50, borderRadius: BorderRadius.circular(15)),
          child: const Column(children: [
            Icon(Icons.lightbulb, color: Colors.blueAccent),
            SizedBox(height: 10),
            Text(
                'Tip: Users who complete their profile are 40% more likely to get an interview match!',
                textAlign: TextAlign.center),
          ]),
        ),
      ]),
    );
  }
}
