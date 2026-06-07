// lib/screens/report_screen.dart
// DESIGN PATTERN: Template Method (extends AbilityScreen)
import 'package:flutter/material.dart';
import '../app_components.dart';

class ReportScreen extends AbilityScreen {
  const ReportScreen() : super('Report an Issue');

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.red.shade50, borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.shade200)),
          child: const Row(children: [
            Icon(Icons.shield, color: Colors.red),
            SizedBox(width: 10),
            Expanded(child: Text(
                'AbilityBridge is a safe space. All reports are confidential.',
                style: TextStyle(color: Colors.red))),
          ]),
        ),
        const SizedBox(height: 25),
        const Text('Issue Type', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const TextField(
            decoration: InputDecoration(
                hintText: 'e.g., Inaccessible Job Post, Harassment',
                border: OutlineInputBorder())),
        const SizedBox(height: 20),
        const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        const TextField(maxLines: 6,
            decoration: InputDecoration(
                hintText: 'Please provide as much detail as possible...',
                border: OutlineInputBorder())),
        const SizedBox(height: 30),
        CustomButton(
          label: 'Submit Secure Report',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report sent securely to Admin.')));
            Navigator.pop(context);
          },
        ),
      ]),
    );
  }
}
