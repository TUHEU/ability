// lib/app_components.dart
// DESIGN PATTERN: Template Method — AbilityScreen defines the scaffold skeleton;
//                 subclasses override buildBody() to provide content.
import 'package:flutter/material.dart';

abstract class AbilityScreen extends StatelessWidget {
  final String title;
  const AbilityScreen(this.title, {super.key});

  // Template method — subclasses implement this
  Widget buildBody(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.report_gmailerrorred),
              onPressed: () => Navigator.pushNamed(context, '/report')),
          IconButton(icon: const Icon(Icons.account_circle),
              onPressed: () => Navigator.pushNamed(context, '/profile')),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildBody(context),
        ),
      ),
    );
  }
}

// ── Shared reusable button ──────────────────────────────────────────────────
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool primary;

  const CustomButton({required this.label, required this.onTap, this.primary = true, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:  primary ? Colors.blueAccent : Colors.grey[200],
          foregroundColor:  primary ? Colors.white       : Colors.black,
          minimumSize:      const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// ── Stat box used by ImpactReportScreen ─────────────────────────────────────
class StatBox extends StatelessWidget {
  final String number;
  final String label;
  final Color  color;
  const StatBox(this.number, this.label, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, spreadRadius: 2)],
      ),
      child: Column(children: [
        Text(number, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ]),
    );
  }
}
